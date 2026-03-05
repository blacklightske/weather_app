import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().loadCounties();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Button that disables itself during loading
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                final isLoading = state.status == WeatherStatus.loading;

                return ElevatedButton(
                  onPressed: () {
                    final city = controller.text.trim();
                    if (city.isNotEmpty) {
                      context.read<WeatherCubit>().fetchWeather(city);
                    }
                  },
                  child: Text(isLoading ? 'Searching...' : 'Get Weather'),
                );
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                final city = controller.text.trim();

                context.read<WeatherCubit>().showCounties();
              },
              child: Text('Back to counties'),
            ),

            const SizedBox(height: 32),

            // ✅ Result area (loading / loaded / error / initial)
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state.status == WeatherStatus.loading) {
                  return const CircularProgressIndicator();
                }

                if (state.status == WeatherStatus.loaded) {
                  if (state.data != null) {
                    return Column(
                      children: [
                        Text(state.data!.city),
                        Text(
                          '${state.data!.temperature} °C',
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(state.data!.description),
                      ],
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];

                        return ListTile(
                          onTap: () => context
                              .read<WeatherCubit>()
                              .fetchWeather(item.city),
                          title: Text(item.city),
                          subtitle: Text(item.description),
                          trailing: Text('${item.temperature} °C'),
                        );
                      },
                    ),
                  );
                }

                if (state.status == WeatherStatus.error) {
                  return Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                return const Text('Enter a city to get weather');
              },
            ),
          ],
        ),
      ),
    );
  }
}
