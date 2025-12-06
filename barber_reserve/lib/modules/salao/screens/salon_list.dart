import 'package:barber_reserve/modules/salao/services/salao_service.dart';
import 'package:barber_reserve/modules/servico/screens/services_screen.dart';
import 'package:flutter/material.dart';
class HomeSalonsScreen extends StatefulWidget {
  const HomeSalonsScreen({super.key});

  @override
  State<HomeSalonsScreen> createState() => _HomeSalonsScreenState();
}

class _HomeSalonsScreenState extends State<HomeSalonsScreen> {
  List<dynamic> saloes = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarSaloes();
  }

  Future<void> carregarSaloes() async {
    final resposta = await SalaoService.getTodosSalao();

    if (resposta["statusCode"] == 200) {
      setState(() {
        saloes = resposta["body"]; // LISTA DINÂMICA DA API
        carregando = false;
      });
    } else {
      setState(() => carregando = false);
      // opcional: mostrar erro
      print("Erro ao buscar salões: ${resposta['body']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // TÍTULO
                    Center(
                      child: Text(
                        "Encontre sua Barbearia Ideal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF4F8EF7),
                                Color(0xFF8E2DE2),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 200, 0),
                            ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        "Explore os melhores salões e profissionais perto de você",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),

                    const SizedBox(height: 20),

                    

                    const SizedBox(height: 20),

                    
                    Column(
                      children: saloes.map((s) {
                        return _salonCard(
                        salaoId: s["id"],
                        nome: s["nome"] ?? "Sem nome",
                        endereco: "Endereço não cadastrado",
                        descricao: "Descrição não informada",
                        imagem: "assets/images/default_salao.png",
                      );

                      }).toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // INPUTS
  Widget _searchInput(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CARD DINÂMICO
Widget _salonCard({
  required int salaoId,
  required String nome,
  required String endereco,
  required String descricao,
  required String imagem,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Image.asset(
            imagem,
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      endereco,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                descricao,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              
              SizedBox(
                width: double.infinity,
                child: _buttonVerServicos(salaoId),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

 Widget _buttonVerServicos(int salaoId) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicesScreen(salaoId: salaoId),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F8EF7),
            Color(0xFF8E2DE2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: const Text(
          "Ver Serviços >",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

 
}
