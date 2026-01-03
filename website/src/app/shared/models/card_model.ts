import { Servico} from "./servico_model";

export interface CardModel{
    icone:any;
    descricao:string;
    subDescricao:string;
    servicos: Servico[]
}