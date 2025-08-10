import 'package:flutter/material.dart';
import 'package:unetpedia/ui/qualifications/views/views.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/appbar_layout.dart';
import 'package:unetpedia/widgets/inputs/search_input.dart';
import 'package:unetpedia/widgets/main_appbar.dart';

class TutorsView extends StatefulWidget {
  const TutorsView({super.key});

  static const String routeName = 'tutors_view';

  @override
  State<TutorsView> createState() => _TutorsViewState();
}

class _TutorsViewState extends State<TutorsView> {
  final _debouncer = Debouncer(milliseconds: 400);
  String _query = '';

  // mock data para la UI (cámbialo por tu fuente real)
  final List<_Tutor> _tutors = const [
    _Tutor(
      name: 'Daniela Monsalve',
      subject: 'Matemática I',
      price: 5.00,
      image: 'assets/images/tutor1.jpg',
    ),
    _Tutor(
      name: 'Ivan Reyes',
      subject: 'Matemática II',
      price: 5.00,
      image: 'assets/images/tutor2.jpg',
    ),
    _Tutor(
      name: 'Jesus Ortega',
      subject: 'Matemática I',
      price: 5.00,
      image: 'assets/images/tutor3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _tutors
        .where(
          (t) =>
              t.name.toLowerCase().contains(_query.toLowerCase()) ||
              t.subject.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const MainAppBar(title: "Unet Pedia"),
      body: Column(
        children: [
          // Header negro + buscador (usa tu AppBarLayout para mantener estilo del resto de la app)
          AppBarLayout(
            child: SearchInput(
              hintText: "Buscar Tutores",
              prefixIcon: Icons.search_rounded,
              onChange: (v) {
                _debouncer.run(() => setState(() => _query = v));
              },
            ),
          ),
          const SizedBox(height: 12),
          // Píldora "Tutores"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Tutores',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Listado
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) => _TutorCard(tutor: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorCard extends StatelessWidget {
  const _TutorCard({required this.tutor});

  final _Tutor tutor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          TutorDetailView.routeName,
          arguments: TutorDetailArgs(
            name: tutor.name,
            subject: tutor.subject,
            image: tutor.image, // soporta asset o http
            about:
                "Soy estudiante de Ing. Informatica, y he eximido mis materias. Me gustan las matemáticas y tengo buena pedagogía para enseñarlas.",
            hours: 120,
            students: 100,
            rating: 4.8,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 4),
              color: Color(0x14000000), // sombra suave
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Avatar con borde azul como en el mock
              Container(
                width: 100,
                height: 130,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 25, 41, 76),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(tutor.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              // Nombre + materia
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tutor.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Precio a la derecha
              Text(
                "\$${tutor.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tutor {
  final String name;
  final String subject;
  final double price;
  final String image;

  const _Tutor({
    required this.name,
    required this.subject,
    required this.price,
    required this.image,
  });
}
