import { Component, OnInit } from '@angular/core';
import { Servico } from '../../shared/models/servico_model';
import { LucideAngularModule, Layers, Wrench, Palette  } from "lucide-angular";
import { CardModel } from '../../shared/models/card_model';
import { ServicosService } from '../../shared/services/servicos-service/servicos-service';
import { servicos_adicionar } from '../../shared/mocks/servicos';
import { DecimalPipe } from '@angular/common';

@Component({
  selector: 'app-servicos-precos',
  imports: [LucideAngularModule, DecimalPipe],
  templateUrl: './servicos-precos.html',
  styleUrl: './servicos-precos.css',
})
export class ServicosPrecos implements OnInit {

  constructor(private readonly servicosService: ServicosService){}

  servicos : Servico[] = []

  async ngOnInit(){
    this.servicos = await this.servicosService.getServicos() as Servico[];

    console.log("Serviços encontrados: ", this.servicos);

  }
  
  get alongamento_unhas (){

    return this.servicos.filter(servico => servico.categoria == "Alongamento" && servico.servicoAtivo);

  }

  get manutencoes (){
    return this.servicos.filter(servico => servico.categoria == "Manutencao" && servico.servicoAtivo);
  }

  get extras (){
    return this.servicos.filter(servico => servico.categoria == "Extras" && servico.servicoAtivo);
  }

  readonly Layers = Layers;
  readonly Wrench = Wrench;
  readonly Pallete = Palette;


  get cards() : CardModel[] {

  
    return [

      {
        icone: Layers,
        descricao: "Alongamento de unhas",
        subDescricao: "Todos os procedimentos incluem cutilagem e esmaltação com esmalte comum",
        servicos: [...this.alongamento_unhas]
      },
      {
        icone: Wrench,
        descricao: "Manutenções",
        subDescricao: "Todos os procedimentos incluem cutilagem e esmaltação com esmalte comum",
        servicos: [...this.manutencoes]
      },
      
      {
        icone: Palette,
        descricao: "Extras / Acréscimos / Decoração",
        subDescricao: "Personalize suas unhas com acabamentos especiais",
        servicos: [...this.extras]
      },
    ];
  }

}
