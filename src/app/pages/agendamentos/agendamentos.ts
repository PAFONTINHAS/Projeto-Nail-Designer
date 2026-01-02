import { Component, LOCALE_ID, OnInit } from '@angular/core';
import { LucideAngularModule, CircleAlert, Clock } from 'lucide-angular';
import { Servico } from '../../shared/models/servico_model';
import { CommonModule } from '@angular/common';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatCardModule } from '@angular/material/card';
import { MatNativeDateModule, MAT_DATE_LOCALE } from '@angular/material/core';
import { AgendamentoService } from '../../shared/services/agendamento-service/agendamento-service';
import { ServicosService } from '../../shared/services/servicos-service/servicos-service';

@Component({
  selector: 'app-agendamentos',
  imports: [
    LucideAngularModule,
    CommonModule,
    MatCardModule,
    MatDatepickerModule,
    MatNativeDateModule,
  ],
  templateUrl: './agendamentos.html',
  styleUrls: ['./agendamentos.css', './calendar.css'],
})
export class Agendamentos implements OnInit{

  

  constructor(private readonly agendamentoService: AgendamentoService, private readonly servicosService: ServicosService){}

  readonly CircleAlert = CircleAlert;
  readonly Clock = Clock;

  
  servicos : Servico[] = []

  async ngOnInit() {
    this.servicos = await this.servicosService.getServicos() as Servico[];
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


  servicosSelecionados: Servico[] = [];
  dataSelecionada: Date | null = null;
  horarioSelecionado: string | null = null;

  horariosDisponiveis: string[] = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
  ];

  categoriaAtiva: string = 'Alongamento';

  get servicosDisponiveis() {
    return this.servicos.filter((s) => s.categoria == this.categoriaAtiva);
  }

  toggleServico(servico: Servico) {
    const index = this.servicosSelecionados.findIndex(
      (s) => s.id === servico.id
    );

    if (index > -1) {
      this.servicosSelecionados.splice(index, 1);
    } else {
      this.servicosSelecionados.push(servico);
    }
  }


  selecionarData(data: Date | null) {
    if (!data) return;

    this.dataSelecionada = data;
    this.horarioSelecionado = null;
    
    this.agendamentoService.getAgendamentosDoDia(data).subscribe(agendamentos => {
      console.log('Agendamentos ocupados: ', agendamentos);
      this.atualizarHorariosDisponiveis(agendamentos);
    })
  }


  atualizarHorariosDisponiveis(agendamentosOcupados: any[]){
    const gradePadrao = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
    const duracaoDesejada = this.totalDuracao;

    this.horariosDisponiveis = gradePadrao.filter(horario => {
      const [hora, minuto] = horario.split(':').map(Number);
      const inicioProposto = hora * 60 + minuto;
      const fimProposto = inicioProposto + duracaoDesejada;

      const conflito = agendamentosOcupados.some(agendamento =>{
        const dataAgendada : Date = agendamento.data.toDate();
        const inicioOcupado = dataAgendada.getHours() * 60 + dataAgendada.getMinutes();
        const fimOcupado = inicioOcupado + agendamento.duracaoTotal;

        return inicioProposto < fimOcupado  && fimProposto > inicioOcupado;
      });

      !conflito;
    })
  }

  selecionarHorario(hora: string) {
    this.horarioSelecionado = hora;
  }

  toggleCategoria(categoria: string) {
    this.categoriaAtiva = categoria;
  }

  isServicoSelecionado(servicoId: string): boolean {
    return this.servicosSelecionados.some((s) => s.id === servicoId);
  }

  isCategoriaSelecionada(categoriaNome: string): boolean {
    return this.categoriaAtiva == categoriaNome;
  }

  get totalPreco() {
    return this.servicosSelecionados.reduce(
      (total, servico) => total + servico.preco,
      0
    );
  }

  get totalDuracao() {
    return this.servicosSelecionados.reduce(
      (total, servico) => total + servico.duracao,
      0
    );
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
