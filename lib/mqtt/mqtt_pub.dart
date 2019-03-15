import 'package:mqtt_client/mqtt_client.dart';
Publish(String Message) async {
  final MqttClient client =
      new MqttClient.withPort("broker.hivemq.com", "From_switch", 1883);

  try {
    await client.connect();
  } catch (e) {
    print("EXAMPLE::client exception - $e");
    client.disconnect();
  }
  final String pubTopic = "messagefromdpitoswitch";
  final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
  builder.addString(Message);

  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);

}
