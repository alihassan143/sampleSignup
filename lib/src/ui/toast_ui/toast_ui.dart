import '../ui.dart';

class ToastUi extends StatelessWidget {
  final String message;

  const ToastUi({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
