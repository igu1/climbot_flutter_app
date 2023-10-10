import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataPage extends StatelessWidget {
  final String stationName;
  final String latitude;
  final String longitude;
  final String altitude;
  final String address;
  final List<String> liveData;

  DataPage({
    required this.stationName,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.address,
    required this.liveData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Page'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildDataRow('Station Name', stationName),
          _buildDataRow('Latitude', latitude),
          _buildDataRow('Longitude', longitude),
          _buildDataRow('Altitude', altitude),
          _buildDataRow('Address', address),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Live Weather Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          _buildWeatherDataRow('Date and Time', liveData[0]),
          _buildWeatherDataRow('Temperature [°C]', liveData[1]),
          _buildWeatherDataRow('Relative Humidity [%]', liveData[2]),
          _buildWeatherDataRow('Pressure [hPa]', liveData[3]),
        ],
      ),
    );
  }

  Widget _buildDataRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDataRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Flexible(
            flex: 2,
            child: Text(
              data,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
