import { Timestamp } from "rxjs";

export interface Agendamento{
    clienteNome: string;
    data: Date;
    servicos: number[];
    duracaoTotal: number;
    // finalizado: boolean;
    notificacaoEnviada: boolean;
    status: string;
}
