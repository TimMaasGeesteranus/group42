import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
        Container(
          padding : const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 100.0),
              Text(
                "Welcome!",
                style: Theme.of(context).textTheme.displayMedium
              ),
              SizedBox(height: 20.0),
              Text(
                   "We are glad to see you. Say goodbye to conflicts and hello to seamless living. HoPla is here to make your life more enjoyable ",
                  style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center
              ),
              SizedBox(height: 100.0),

              ElevatedButton(
                  onPressed: onGetStartedClicked,
                  child: const Text("Schedule, share, succeed!"))
            ],
          )


        );
  }

  onGetStartedClicked(){
    print("lets gooo");
  }


}
