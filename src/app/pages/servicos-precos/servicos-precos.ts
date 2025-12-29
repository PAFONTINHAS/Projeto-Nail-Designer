import { Component } from '@angular/core';
import { ServicoModel } from '../../shared/models/servico_model';
import { LucideAngularModule, Layers, Wrench, Palette  } from "lucide-angular";
import { CardModel } from '../../shared/models/card_model';

@Component({
  selector: 'app-servicos-precos',
  imports: [LucideAngularModule],
  templateUrl: './servicos-precos.html',
  styleUrl: './servicos-precos.css',
})
export class ServicosPrecos {

  

  readonly Layers = Layers;
  readonly Wrench = Wrench;
  readonly Pallete = Palette;

  alongamento_unhas : ServicoModel[] = [
    {servico: "Fibra de vidro", preco: "R$ 180,00"},
    {servico: "Acrílico",       preco: "R$ 190,00"},
    {servico: "Molde F1",       preco: "R$ 130,00"},
    {servico: "Tips",           preco: "R$ 140,00"},
    {servico: "Banho de Gel",   preco: "R$ 95,00"},
    {servico: "Blindagem",      preco: "R$ 90,00"},
  ];

  manutencoes: ServicoModel[] = [
    {servico: "Fibra de vidro", preco: "R$ 110,00"},
    {servico: "Acrílico",       preco: "R$ 120,00"},
    {servico: "Molde F1",       preco: "R$ 100,00"},
    {servico: "Tips",           preco: "R$ 105,00"},
  ];

  extras: ServicoModel[] = [
    {servico: "Remoção para nova colocação",                       preco: "R$ 25,00"},
    {servico: "Remoção total",                                     preco: "R$ 55,00"},
    {servico: "Reposição de Unhas",                                preco: "R$ 10,00"},
    {servico: "Esmaltação em gel",                                 preco: "R$ 30,00"},
    {servico: "Babyboomer",                                        preco: "R$ 30,00"},
    {servico: "Babycolor",                                         preco: "R$ 30,00"},
    {servico: "Babyglitter",                                       preco: "R$ 30,00"},
    {servico: "Encapsulada (o par)",                               preco: "R$ 20,00"},
    {servico: "Francesa Reversa (o par)",                          preco: "R$ 20,00"},
    {servico: "Decorações - pedraria/traços/animal print (o par)", preco: "R$ 15,00"},
    {servico: "Troca de formato",                                  preco: "R$ 30,00"},
 
  ]

  cards: CardModel[] = [

    {
      icone: Layers,
      descricao: "Alongamento de unhas",
      subDescricao: "Todos os procedimentos incluem cutilagem e esmaltação com esmalte comum",
      servicos: this.alongamento_unhas
    },
    {
      icone: Wrench,
      descricao: "Manutenções",
      subDescricao: "Todos os procedimentos incluem cutilagem e esmaltação com esmalte comum",
      servicos: this.manutencoes
    },
    
    {
      icone: Palette,
      descricao: "Extras / Acréscimos / Decoração",
      subDescricao: "Personalize suas unhas com acabamentos especiais",
      servicos: this.extras
    },

  ]


}
