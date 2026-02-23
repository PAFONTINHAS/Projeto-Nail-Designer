import { Timestamp } from "rxjs";

export interface Agendamento{
    clienteNome: string;
    data: Date;
    servicos: number[];
    duracaoTotal: number;
    // finalizado: boolean;
    status: string;
}
