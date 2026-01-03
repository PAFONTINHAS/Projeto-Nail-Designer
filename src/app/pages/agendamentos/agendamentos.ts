import { Component, LOCALE_ID, OnInit } from '@angular/core';
import { LucideAngularModule, CircleAlert, Clock } from 'lucide-angular';
import { Servico } from '../../shared/models/servico_model';
import { CommonModule } from '@angular/common';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatCardModule } from '@angular/material/card';
import { MatNativeDateModule, MAT_DATE_LOCALE } from '@angular/material/core';
import { AgendamentoService } from '../../shared/services/agendamento-service/agendamento-service';
import { ServicosService } from '../../shared/services/servicos-service/servicos-service';
import { NgxMaskDirective } from "ngx-mask";

@Component({
  selector: 'app-agendamentos',
  imports: [
    LucideAngularModule,
    CommonModule,
    MatCardModule,
    MatDatepickerModule,
    MatNativeDateModule,
    NgxMaskDirective,
  ],
  templateUrl: './agendamentos.html',
  styleUrls: [
    './css/agendamentos.css',
    './css/calendar.css',
    './css/dados-cliente.css',
    './css/servicos-grid.css',
    './css/horarios-coluna.css',
    './css/media-query.css',
  ],
})
export class Agendamentos implements OnInit {
  constructor(
    private readonly agendamentoService: AgendamentoService,
    private readonly servicosService: ServicosService
  ) {}

  agendamentoSolicitado: boolean = false;

  horarioStatus: { hora: string; ocupado: boolean }[] = [];

  readonly CircleAlert = CircleAlert;
  readonly Clock = Clock;

  servicos: Servico[] = [];

  async ngOnInit() {
    this.servicos = (await this.servicosService.getServicos()) as Servico[];
  }

  get alongamento_unhas() {
    return this.servicos.filter(
      (servico) => servico.categoria == 'Alongamento'
    );
  }

  get manutencoes() {
    return this.servicos.filter((servico) => servico.categoria == 'Manutencao');
  }

  get extras() {
    return this.servicos.filter((servico) => servico.categoria == 'Extras');
  }

  cliente: { nome: string; contato: string } = { nome: '', contato: '' };

  servicosSelecionados: Servico[] = [];
  dataSelecionada: Date | null = null;
  horarioSelecionado: string | null = null;



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

    this.horarioSelecionado = null;
  }

  selecionarData(data: Date | null) {
    if (!data) return;

    this.dataSelecionada = data;
    this.horarioSelecionado = null;

    this.agendamentoService
      .getAgendamentosDoDia(data)
      .subscribe((agendamentos) => {
        console.log('Agendamentos ocupados: ', agendamentos);
        this.atualizarHorariosDisponiveis(agendamentos);
      });
  }

  prosseguirAgendamento() {
    this.agendamentoSolicitado = true;
  }

  limparCampos() {
    this.agendamentoSolicitado = false;
    this.dataSelecionada = null;
    this.horarioSelecionado = null;
    this.servicosSelecionados = [];
    this.horarioStatus = [];
  }

  async finalizarAgendamento(nome: string, contato: string) {
    if (!this.dataSelecionada || !this.horarioSelecionado) return;

    const dataFinal = new Date(this.dataSelecionada);

    const [horas, minutos] = this.horarioSelecionado.split(':').map(Number);
    dataFinal.setHours(horas, minutos);

    const novoAgendamento = {
      data: dataFinal, // O SDK do Firebase converterá automaticamente para Timestamp
      servicos: this.servicosSelecionados.map((s) => s.id),
      duracaoTotal: this.totalDuracao,
      valorTotal: this.totalPreco,
      clienteNome: nome,
      contato: contato, // Depois você pega isso de um input ou Auth
      finalizado: false,
    };

    try {
      await this.agendamentoService.salvarAgendamento(novoAgendamento as any);
      alert('Agendamento realizado com sucesso!');
      this.limparCampos();
    } catch (error) {
      console.error('Erro ao salvar: ', error);
    }
  }

  atualizarHorariosDisponiveis(agendamentosOcupados: any[]) {
    const gradePadrao = [
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
    ];
    const duracaoDesejada = this.totalDuracao;

    this.horarioStatus = gradePadrao.map((horario) => {
      const [hora, minuto] = horario.split(':').map(Number);
      const inicioProposto = hora * 60 + minuto;
      const fimProposto = inicioProposto + duracaoDesejada;

      const conflito = agendamentosOcupados.some((agendamento) => {
        const dataAgendada: Date = agendamento.data.toDate();
        const inicioOcupado =
          dataAgendada.getHours() * 60 + dataAgendada.getMinutes();
        const fimOcupado = inicioOcupado + agendamento.duracaoTotal;

        const inicioSobreposto =
          inicioProposto >= inicioOcupado && inicioProposto < fimOcupado;
        const fimSobreposto =
          fimProposto > inicioOcupado && fimProposto <= fimOcupado;
        const englobaOcupado =
          inicioProposto <= inicioOcupado && fimProposto >= fimOcupado;

        return inicioSobreposto || fimSobreposto || englobaOcupado;
      });

      return {
        hora: horario,
        ocupado: conflito,
      };
    });
  }

  selecionarHorario(hora: string) {
    const [h, m] = hora.split(':').map(Number);
    const inicio = h * 60 + m;
    const fim = inicio + this.totalDuracao;

    // Exemplo: Salão fecha às 18:00 (1080 minutos)
    if (fim > 1080) {
      alert(
        'Este serviço termina após o horário de fechamento. Escolha um horário mais cedo.'
      );
      return;
    }

    const conflitoNoIntervalo = this.horarioStatus.some(item => {
      const [hItem, mItem] = item.hora.split(':').map(Number);
      const minutoItem = hItem * 60 + mItem;

      const estariaNoCaminho = minutoItem >= inicio && minutoItem < fim;

      return item.ocupado && estariaNoCaminho;
    });

    if (conflitoNoIntervalo) {
        alert('A duração deste serviço conflita com um horário já reservado adiante.');
        return;
      }


    this.horarioSelecionado = hora;
  }

  isNoIntervaloSelecionado(horaCard: string): boolean {
    if (!this.horarioSelecionado) return false;

    const [hsel, mSel] = this.horarioSelecionado.split(':').map(Number);
    const inicioMinutos = hsel * 60 + mSel;

    const fimMinutos = inicioMinutos + this.totalDuracao;

    const [hCard, mCard] = horaCard.split(':').map(Number);
    const cardMinutos = hCard * 60 + mCard;

    return cardMinutos >= inicioMinutos && cardMinutos < fimMinutos;
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

  get totalValor() {
    return this.servicosSelecionados.reduce(
      (total, servico) => total + servico.preco,
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
