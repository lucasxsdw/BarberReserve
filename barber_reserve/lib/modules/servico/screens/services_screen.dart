import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../../profissional/models/professional_model.dart';
import '../../agendamento/models/appointment_model.dart';
import '../services/service_service.dart';
import '../../agendamento/services/appointment_service.dart';

class ServicesScreen extends StatefulWidget {
 
  final int salaoId;

  const ServicesScreen({super.key, required this.salaoId});
 
     
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late Future<List<ServiceModel>> futureServicos;

  ServiceModel? servicoSelecionado;
  Professional? profissionalSelecionado;
  DateTime? dataSelecionada;
  String? horarioSelecionado;

  @override
  void initState() {
    super.initState();
    // usa método estático do service
    futureServicos = ServiceService.getServicosDoSalao(widget.salaoId);

  }

  Widget gradientButton({
    required String text,
    required VoidCallback? onPressed,
    double radius = 12,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  }) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2EA7FF), Color(0xFF6E40F7)],
            ),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void abrirModalAgendar(ServiceModel servico) {
    servicoSelecionado = servico;
    profissionalSelecionado ??=
        servico.profissionais.isNotEmpty ? servico.profissionais.first : null;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setStateModal) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Agendar: ${servico.titulo}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.content_cut,
                              color: Color(0xFF2EA7FF),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  servico.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  servico.descricao ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${servico.duracaoMinutos}min',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'R\$ ${servico.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Professional>(
                      value: profissionalSelecionado,
                      items: servico.profissionais
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.nome),
                            ),
                          )
                          .toList(),
                      onChanged: (p) {
                        setStateModal(() => profissionalSelecionado = p);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Escolha o profissional',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    gradientButton(
                      text: 'Escolher Data e Horário',
                      onPressed: () {
                        Navigator.pop(context);
                        abrirCalendario();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void abrirCalendario() {
    DateTime hoje = DateTime.now();
    DateTime selecionada = dataSelecionada ?? hoje;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Escolha a Data',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 360,
                      child: CalendarDatePicker(
                        initialDate: selecionada,
                        firstDate: hoje,
                        lastDate: DateTime(2030, 12, 31),
                        onDateChanged: (d) {
                          setStateModal(() => selecionada = d);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    gradientButton(
                      text: 'Escolher Data',
                      onPressed: () {
                        dataSelecionada = selecionada;
                        Navigator.pop(context);
                        abrirHorarios();
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void abrirHorarios() {
    final horarios = [
      "08:00",
      "08:30",
      "09:00",
      "09:30",
      "10:00",
      "10:30",
      "11:00",
      "11:30",
      "12:00",
    ];

    horarioSelecionado = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Escolha seu horário',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: horarios.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final h = horarios[index];
                          final even = index % 2 == 0;
                          final selected = horarioSelecionado == h;
                          return InkWell(
                            onTap: () {
                              setStateModal(() => horarioSelecionado = h);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFE8F4FF)
                                    : (even
                                        ? Colors.grey.shade100
                                        : Colors.grey.shade50),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF2EA7FF)
                                      : Colors.transparent,
                                  width: selected ? 1.4 : 0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      h,
                                      style: TextStyle(
                                        fontWeight: selected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF2EA7FF),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    gradientButton(
                      text: 'Escolher Horário',
                      onPressed: horarioSelecionado == null
                          ? null
                          : () async {
                              Navigator.pop(context);
                              await confirmarAgendamento();
                            },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> confirmarAgendamento() async {
    if (servicoSelecionado == null ||
        profissionalSelecionado == null ||
        dataSelecionada == null ||
        horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os dados antes de confirmar'),
        ),
      );
      return;
    }

    String horaFim = calculeEndTime(horarioSelecionado, servicoSelecionado?.duracaoMinutos);

    final ag = Appointment(
      servico: servicoSelecionado!,
      profissional: profissionalSelecionado!,
      data: dataSelecionada!,
      horaInicio: horarioSelecionado!,
      horaFim: horaFim,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await AppointmentService.enviarAgendamento(ag);

    if (mounted) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Agendamento realizado com sucesso!'
              : 'Erro ao enviar agendamento.',
        ),
      ),
    );

    if (success) {
      setState(() {
        servicoSelecionado = null;
        profissionalSelecionado = null;
        dataSelecionada = null;
        horarioSelecionado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2EA7FF), Color(0xFF6E40F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serviços',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Escolha um serviço perfeito para você',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: FutureBuilder<List<ServiceModel>>(
              future: futureServicos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Erro ao carregar serviços'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              futureServicos = ServiceService.getServicosDoSalao(widget.salaoId);
                            });
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final servicos = snapshot.data ?? [];

                if (servicos.isEmpty) {
                  return const Center(
                    child: Text('Nenhum serviço cadastrado.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  itemCount: servicos.length,
                  itemBuilder: (context, index) {
                    final s = servicos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F4FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.content_cut,
                                    color: Color(0xFF2EA7FF),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        s.descricao ?? '',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'R\$ ${s.preco.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${s.duracaoMinutos} min',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Profissionais disponíveis: '
                              '${s.profissionais.map((p) => p.nome).join(', ')}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => abrirModalAgendar(s),
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2EA7FF),
                                            Color(0xFF6E40F7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Agendar Serviço',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String calculeEndTime(String? horarioSelecionado, int? duracaoMinutos) {
    if(horarioSelecionado == null || duracaoMinutos == null){
        return "";
    }

    var horaInicio = horarioSelecionado;

    var valores = horaInicio.split(":");
    var hora = int.parse(valores[0]); 
    var minutos = int.parse(valores[1]); 

    int totalMinutos = hora * 60 + minutos + duracaoMinutos;

    var horaFim = (totalMinutos ~/ 60) % 24;
    var minutosFim = totalMinutos % 60;

    return "${horaFim.toString()}:${minutosFim.toString()}";
  }