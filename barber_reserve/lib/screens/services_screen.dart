import 'package:barber_reserve/screens/home_screen.dart';
import 'package:barber_reserve/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class ServicosScreen extends StatefulWidget {
  const ServicosScreen({super.key});

  @override
  State<ServicosScreen> createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  String selectedCategory = 'Todos';
  final categories = ['Todos', 'Cabelo', 'Sobrancelha', 'Barba'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Cabeçalho com gradiente ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B61FF), Color(0xFF00B4DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nossos Serviços',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Escolha um serviço perfeito para você',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Campo de busca ---
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar serviços...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Botões de categorias ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: const Color(0xFF7B61FF),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setState(() => selectedCategory = category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // --- Card 1: Cabelo ---
              _buildServicoCard(
                icon: Icons.cut,
                titulo: 'Cabelo',
                descricao: 'Corte moderno e estiloso',
                duracao: '30 minutos',
                preco: 'R\$ 30,00',
                imagemProfissional:
                    'https://randomuser.me/api/portraits/men/31.jpg',
              ),
              const SizedBox(height: 12),

              // --- Card 2: Sobrancelha ---
              _buildServicoCard(
                icon: Icons.cut,
                titulo: 'Sobrancelha',
                descricao: 'Corte moderno e estiloso',
                duracao: '20 minutos',
                preco: 'R\$ 25,00',
                imagemProfissional:
                    'https://randomuser.me/api/portraits/men/18.jpg',
              ),
              const SizedBox(height: 80), // espaço para o rodapé
            ],
          ),
        ),
      ),

      // --- Rodapé visual (BottomNavigationBar estática) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          
         // Botão de agenda com navegação
           GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaInicial()),
              );
            },
            child: _bottomItem(Icons.person, 'Agenda', false),
          ),

 
          // Botão de serviços com navegação
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicosScreen()),
              );
            },
            child: _bottomItem(Icons.person, 'Serviços', false),
          ),



          // Botão de perfil com navegação
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
            },
            child: _bottomItem(Icons.person, 'Perfil', false),
          ),
        ],
      ),

      ),
    );
  }

  // --- Função de criação dos itens do rodapé ---
  Widget _bottomItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF7B61FF) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF7B61FF) : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // --- Função para construir os cards de serviço ---
  Widget _buildServicoCard({
    required IconData icon,
    required String titulo,
    required String descricao,
    required String duracao,
    required String preco,
    required String imagemProfissional,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone + título
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.cut, color: Color(0xFF7B61FF)),
              ),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Descrição
          Text(
            descricao,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),

          // Duração e Preço
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    duracao,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              Text(
                preco,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Profissionais
          const Text(
            'Profissionais disponíveis:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          CircleAvatar(
            backgroundImage: NetworkImage(imagemProfissional),
            radius: 16,
          ),
          const SizedBox(height: 12),

          // Botão Agendar Serviço
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4DB), Color(0xFF7B61FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Agendar Serviço',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
