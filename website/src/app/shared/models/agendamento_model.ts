import { Timestamp } from "rxjs";

export interface Agendamento{
    data: Date;
    status: string;
    servicos: string[];
    valorTotal: number;
    nomeCliente: string;
    duracaoTotal: number;
    contatoCliente:string;
    // finalizado: boolean;
    notificacaoEnviada: boolean;
}
