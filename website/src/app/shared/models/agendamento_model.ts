import { Timestamp } from "rxjs";

export interface Agendamento{
    data: Date;
    status: string;
    servicos: number[];
    clienteNome: string;
    duracaoTotal: number;
    // finalizado: boolean;
    notificacaoEnviada: boolean;
}
