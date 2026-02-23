import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

export const checkAgendamentos = functions.pubsub.schedule("every 10 minutes")
  .timeZone("America/Sao_Paulo")
  .onRun(async () =>{
    const agora = admin.firestore.Timestamp.now();
    const daqui30Min = admin.firestore.Timestamp.fromDate(
      new Date(agora.toDate().getTime() + 30 * 60000)
    );

    const agendamentosSnapshot = await admin.firestore()
      .collection("agendamentos")
      .where("status", "==", "agendado")
      .where("notificacaoEnviada", "==", false)
      .where("data", "<=", daqui30Min)
      .where("data", ">=", agora)
      .get();

    if (agendamentosSnapshot.empty) {
      console.log("Nenhum agendamento próximo encontrado");
      return null;
    }

    const dispositivoSnapshot = await admin.firestore()
      .collection("dispositivos_autorizados")
      .doc("V1TD35H.83-20-5")
      .get();

    if (!dispositivoSnapshot.exists) {
      console.log("Nenhum token FCM encontrado.");
      return null;
    }

    const token = dispositivoSnapshot.data()!.token;

    const promisses = agendamentosSnapshot.docs.map(async (doc) =>{
      const agendamento = doc.data();

      const dataAtendimento: string = new Date(
        agendamento.data.toDate(),
      ).toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
        timeZone: "America/Sao_Paulo",
        hour12: false,
      });

      const payload = {
        notification: {
          title: "Próximo Atendimento! 💅",
          body: `A cliente ${agendamento.clienteNome}` +
          ` chega às ${dataAtendimento}.`,
        },
        token: token,
      };

      try {
        await admin.messaging().send(payload);

        await doc.ref.update({notificacaoEnviada: true});

        console.log(`Notificação enviada para ${agendamento.nomeCliente}`);
      } catch (e) {
        console.error("Erro ao enviar notificação: ", e);
      }
    });

    return Promise.all(promisses);
  });
