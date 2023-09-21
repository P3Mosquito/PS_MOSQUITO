import 'package:flutter/material.dart';

class MenuMobile extends StatefulWidget {
  @override
  _MenuMobileState createState() => _MenuMobileState();
}

class _MenuMobileState extends State<MenuMobile> with TickerProviderStateMixin {
  bool showImage = false; // Variable to control the visibility of the image

  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Configure the rotation animation
    _rotateController = AnimationController(
      duration: const Duration(seconds: 2), // Duration of the animation
      vsync: this, // Use 'this' as the vsync
    );

    // Start the animation after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showImage = true;
      });
      _rotateController.forward();
    });

    // Define the rotation animation
    _rotateAnimation = Tween<double>(
      begin: 0.0, // Initial angle
      end: 2 * 3.141592653589793, // Final angle (a full rotation in radians)
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // No title is shown in the AppBar
        title: null,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/ciudad.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40, // Adjust the top margin here
            left: 20, // Adjust the left margin here
            right: 20, // Adjust the right margin here
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFD7D9D7),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Visibility(
                          visible:
                              showImage, // Control the visibility of the image
                          child: Image.asset(
                            'assets/images/logo_mosquito.png', // Replace with your image path
                            width: 100, // Image width
                            height: 100, // Image height
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                      height: 10), // Space between the image and the text
                  const Text(
                    'Mosquito Captura y Analiza', // Changed to "Mosquito" instead of "Mosquitobot"
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20, // Decreased font size
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          'Roboto', // Change the font as per your preference
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 200, // Adjust the top margin for the button container
            left: 20, // Adjust the left margin here
            right: 20, // Adjust the right margin here
            child: Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.all(40), // Increased margin for separation
              decoration: const BoxDecoration(
                color: Color(0xFFD7D9D7),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Logic for the tasks action
                      Navigator.of(context).pushNamed('/my_tasks');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF99BF9C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20), // Adjust the button width here
                    ),
                    child: const Text(
                      'Tareas',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logic for the logout action
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF99BF9C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20), // Adjust the button width here
                    ),
                    child: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logic for the map action
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF99BF9C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20), // Adjust the button width here
                    ),
                    child: const Text(
                      'Mapa',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
