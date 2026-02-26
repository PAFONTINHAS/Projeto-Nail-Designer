import { Component, OnDestroy, OnInit } from '@angular/core';
import { Servico } from '../../shared/models/servico_model';
import { LucideAngularModule, Layers, Wrench, Palette  } from "lucide-angular";
import { CardModel } from '../../shared/models/card_model';
import { ServicosService } from '../../shared/services/servicos-service/servicos-service';
import { servicos_adicionar } from '../../shared/mocks/servicos';
import { DecimalPipe } from '@angular/common';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-servicos-precos',
  imports: [LucideAngularModule, DecimalPipe],
  templateUrl: './servicos-precos.html',
  styleUrl: './servicos-precos.css',
})
export class ServicosPrecos implements OnInit, OnDestroy{

  constructor(private readonly servicosService: ServicosService){}

  servicos : Servico[] = []

  servicosSubscription!: Subscription;

  async ngOnInit(){
    // this.servicos = await this.servicosService.getServicos() as Servico[];

    this.servicosSubscription = this.servicosService
      .servicos$
      .subscribe((remoteServicos) =>{

        this.servicos = remoteServicos;

      });

    console.log("Serviços encontrados: ", this.servicos);

  }

  ngOnDestroy(): void {
    if(this.servicosSubscription){
      this.servicosSubscription.unsubscribe();
    }
  }
  
  get alongamento_unhas (){

    return this.servicos.filter(servico => servico.categoria == "Alongamento");

  }

  get manutencoes (){
    return this.servicos.filter(servico => servico.categoria == "Manutencao");
  }

  get extras (){
    return this.servicos.filter(servico => servico.categoria == "Extras");
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
