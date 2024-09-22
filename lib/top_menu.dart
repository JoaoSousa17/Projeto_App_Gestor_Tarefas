import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  final String avatarUrl;
  final String nome;
  final int nivel;
  final int pontuacaoTotal;
  final VoidCallback onOptionsPressed;

  const TopMenu({
    Key? key,
    required this.avatarUrl,
    required this.nome,
    required this.nivel,
    required this.pontuacaoTotal,
    required this.onOptionsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onOptionsPressed,
            icon: Icon(Icons.menu),
            color: Colors.white,
            iconSize: 28,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Nível $nivel',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pontuação: $pontuacaoTotal',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 30, color: Colors.white);
                          },
                        ),
                      )
                    : Icon(Icons.person, size: 30, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
