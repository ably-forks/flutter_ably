import 'package:rxdart/rxdart.dart';

import './channel.dart';
import './client.dart';

import './channel_input_message.dart';
import './channel_message.dart';
import './channel_state.dart';
import './channel_state_change.dart';

class RealtimeChannel implements Channel {
  final Client client;
  final String id;
  final Observable<ChannelMessage> message;
  final Observable<ChannelStateChange> stateChange;
  final Observable<ChannelState> state;

  RealtimeChannel({
    this.client,
    this.id,
    this.message,
    this.stateChange,
    this.state,
  });

  Future<void> setup() async {
    return _call("setup");
  }

  Future<void> dispose() async {
    return _call("dispose");
  }

  Future<void> attach() async {
    return _call("attach");
  }

  Future<void> detach() async {
    return _call("detach");
  }

  Future<void> subscribe(String name) async {
    return _call("subscribe", {"name": name});
  }

  Future<void> unsubscribe() async {
    return _call("unsubscribe");
  }

  Future<void> publish(List<ChannelInputMessage> messages) async {
    return _call("publish", {
      "messages": _serializeChannelInputMessages(messages),
    });
  }

  Future<void> _call(
    String methodName, [
    Map<String, dynamic> args = const {},
  ]) async {
    final Map<String, dynamic> baseArgs = {
      "clientId": client.id,
      "id": id,
    };
    return client.channel.invokeMethod(
      "Realtime::RealtimeChannel#$methodName",
      baseArgs..addAll(args),
    );
  }

  List<Map<String, String>> _serializeChannelInputMessages(
    List<ChannelInputMessage> messages,
  ) {
    return messages
        .map<Map<String, String>>((m) => {
              "name": m.name,
              "data": m.data,
            })
        .toList();
  }
}
