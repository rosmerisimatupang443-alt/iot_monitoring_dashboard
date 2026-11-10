
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const IoTMonitoringApp());
}

class IoTMonitoringApp extends StatelessWidget {
  const IoTMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Monitoring',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF4F9F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double temperature = 28.5;
  double humidity = 65.0;
  bool isConnected = true;
  String lastUpdated = '10:30:25';

  final List<double> chartData = [
    26.0, 27.0, 26.5, 28.0, 27.5, 29.0, 28.5
  ];

  void refreshData() {
    setState(() {
      temperature = 26 + math.Random().nextDouble() * 5;
      humidity = 55 + math.Random().nextDouble() * 20;

      chartData.removeAt(0);
      chartData.add(temperature);

      final now = DateTime.now();

      lastUpdated =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data sensor berhasil diperbarui!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.sensors,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IoT Monitor',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172B4D),
                              ),
                            ),
                            Text(
                              'SMART MONITORING SYSTEM',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.3,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: refreshData,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh data',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // DASHBOARD TITLE
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Monitor kondisi lingkungan secara real-time.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 22),

                  // MQTT STATUS
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14213D),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wifi,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MQTT CONNECTION',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isConnected
                                    ? 'Connected'
                                    : 'Disconnected',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isConnected
                                ? const Color(0xFF176B50)
                                : const Color(0xFF8B3434),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 9,
                                color: isConnected
                                    ? const Color(0xFF55E6A5)
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isConnected ? 'ONLINE' : 'OFFLINE',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Sensor Monitoring',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                  const SizedBox(height: 13),

                  // SENSOR CARDS
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth > 500;

                      final temperatureCard = sensorCard(
                        title: 'Temperature',
                        value: temperature.toStringAsFixed(1),
                        unit: '°C',
                        subtitle: 'Room temperature',
                        icon: Icons.thermostat,
                        color: const Color(0xFF2563EB),
                        background: const Color(0xFFEAF1FF),
                      );

                      final humidityCard = sensorCard(
                        title: 'Humidity',
                        value: humidity.toStringAsFixed(1),
                        unit: '%',
                        subtitle: 'Air humidity',
                        icon: Icons.water_drop,
                        color: const Color(0xFF0D9B8A),
                        background: const Color(0xFFE5F8F5),
                      );

                      if (wide) {
                        return Row(
                          children: [
                            Expanded(child: temperatureCard),
                            const SizedBox(width: 14),
                            Expanded(child: humidityCard),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          temperatureCard,
                          const SizedBox(height: 14),
                          humidityCard,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  // TEMPERATURE CHART
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Temperature History',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B4D),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Monitoring suhu berdasarkan data dummy',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: MonitoringChart(
                              List<double>.from(chartData),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('08:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('09:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('10:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('11:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('12:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('13:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                            Text('14:00', style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // LAST UPDATED
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Data Update',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Waktu pembaruan data sensor',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          lastUpdated,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // REFRESH BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Sensor Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // FOOTER
                  const Center(
                    child: Text(
                      'IoT Monitoring Dashboard • Flutter App',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SENSOR CARD COMPONENT
  Widget sensorCard({
    required String title,
    required String value,
    required String unit,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 23),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// CUSTOM MONITORING CHART
class MonitoringChart extends CustomPainter {
  final List<double> data;

  MonitoringChart(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE9EEF5)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x552563EB),
          Color(0x002563EB),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    // GRID LINES
    for (int i = 0; i < 4; i++) {
      final y = i * size.height / 3;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    if (data.length < 2) return;

    // DATA RANGE
    final minValue = data.reduce(math.min) - 2;
    final maxValue = data.reduce(math.max) + 2;
    final range = maxValue - minValue;

    final points = <Offset>[];

    // CREATE CHART POINTS
    for (int i = 0; i < data.length; i++) {
      final x = i * size.width / (data.length - 1);

      final y = size.height -
          ((data[i] - minValue) / range * size.height);

      points.add(Offset(x, y));
    }

    // LINE PATH
    final path = Path()
      ..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // AREA FILL
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // DATA POINTS
    final dotPaint = Paint()
      ..color = const Color(0xFF2563EB);

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);

      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = const Color(0xFF2563EB).withOpacity(0.15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MonitoringChart oldDelegate) {
    return true;
  }
}
