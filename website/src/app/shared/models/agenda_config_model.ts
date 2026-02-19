import { Timestamp } from "firebase/firestore";

export interface AgendaConfig{

    diasTrabalho: number[];
    horarioInicio: string;
    horarioFim: string;
    datasBloqueadas: string[];
    agendaAtiva:boolean;
}