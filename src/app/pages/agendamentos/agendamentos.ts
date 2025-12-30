import { Component, LOCALE_ID } from '@angular/core';
import { LucideAngularModule, CircleAlert, Clock } from 'lucide-angular';
import { Servico } from '../../shared/models/servico_model';
import { CommonModule } from '@angular/common';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatCardModule } from '@angular/material/card';
import { MatNativeDateModule, MAT_DATE_LOCALE } from '@angular/material/core';

@Component({
  selector: 'app-agendamentos',
  imports: [
    LucideAngularModule, 
    CommonModule, 
    MatCardModule, 
    MatDatepickerModule, 
    MatNativeDateModule
  ],
  templateUrl: './agendamentos.html',
  styleUrls: ['./agendamentos.css', './calendar.css'],
})
export class Agendamentos {

  readonly CircleAlert = CircleAlert;
  readonly Clock = Clock

  servicosSelecionados: Servico[] = []
  dataSelecionada: Date | null = null;
  horarioSelecionado: string | null = null;

  horariosDisponiveis: string[] = ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00'];

  categoriaAtiva:string = 'Alongamento';

  get servicosDisponiveis (){

    return this.servicos.filter(s => s.categoria == this.categoriaAtiva);

  }


 servicos: Servico[] = [
  { id: 1, nome: 'Acrílico', duracao: 120, preco: 190, categoria: 'Alongamento' },
  { id: 2, nome: 'Molde F1', duracao: 90, preco: 130, categoria: 'Manutencao' },
  { id: 3, nome: 'Banho de Gel', duracao: 90, preco: 95, categoria: 'Extras' },
];


toggleServico(servico: Servico){
  const index = this.servicosSelecionados.findIndex(s => s.id === servico.id);

  if(index > -1){
    this.servicosSelecionados.splice(index, 1);
  } else{
    this.servicosSelecionados.push(servico);
  }

}

selecionarData(data: Date | null){
  if(!data) return;
  this.dataSelecionada = data;
  this.horarioSelecionado= null;
  console.log("Data selecionada: ", data);
}

selecionarHorario(hora: string){
  this.horarioSelecionado = hora;
}

toggleCategoria(categoria:string){
  this.categoriaAtiva = categoria


}

isServicoSelecionado(servicoId: number): boolean{
  return this.servicosSelecionados.some(s => s.id === servicoId);
}

isCategoriaSelecionada(categoriaNome: string) : boolean{
  return this.categoriaAtiva == categoriaNome;
}

get totalPreco(){
  return this.servicosSelecionados.reduce((total, servico) => total + servico.preco, 0);
}

get totalDuracao(){
  return this.servicosSelecionados.reduce((total, servico) => total + servico.duracao, 0);
}


filtroDeDatas = (d: Date | null): boolean => {
  const day = (d || new Date()).getDay();
  const time = (d || new Date()).getTime();
  const hoje = new Date();
  hoje.setHours(0, 0, 0, 0);

  // 1. Bloquear dias passados
  if (d! < hoje) return false;

  // 2. Exemplo: Não trabalha aos Domingos (0) e Segundas (1)
  // return day !== 0 && day !== 1;

  // 3. Bloquear uma semana específica (ex: férias)
  const inicioFerias = new Date('2025-01-10').getTime();
  const fimFerias = new Date('2025-01-17').getTime();
  if (time >= inicioFerias && time <= fimFerias) return false;

  return true;
};




}
