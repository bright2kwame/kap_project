import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';

import '../model/chat_message.dart';
import '../util/app_bar_widget.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({
    Key? key,
    required this.receipient,
  }) : super(key: key);
  final UserItem receipient;

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final _nextPageThreshold = 5;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _loadedPages = [];
  String _nextUrl = "";
  UserItem _user = UserItem();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _getChats(ApiUrl().messages(), true);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.data["messageTitle"];
      String messageBody = message.data["messageBody"];

      ChatMessage chatMessage = ChatMessage(
          messageContent: messageBody,
          messageType: MessageType.RECEIPIENT.name);
      messages.add(chatMessage);
    });
    super.initState();
  }

  void _getChats(String url, bool isRefresh) {
    Map<String, String> postData = {};
    postData.putIfAbsent("user_id", () => widget.receipient.id);
    _loadedPages.add(url);
    ApiService.get(_user.token)
        .postData(url, postData)
        .then((value) {
          var statusCode = value["response_code"].toString();
          if (statusCode == "100") {
            _nextUrl = ParseApiData().getJsonData(value, "next");
            value["results"].forEach((item) {
              var dataCleaned =
                  ParseApiData().parseChat(item, widget.receipient.id);
              messages.add(dataCleaned);
            });
            setState(() {});
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBarWidget.primaryAppBar(widget.receipient.username),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == messages.length - _nextPageThreshold &&
                  !_loadedPages.contains(_nextUrl)) {
                _getChats(_nextUrl, false);
              }
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType ==
                          MessageType.RECEIPIENT.name
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType ==
                              MessageType.RECEIPIENT.name
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
                child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  //MARK: the message sent here
  void _sendMessage(String message) {
    Map<String, String> postData = {};
    postData.putIfAbsent("recipient_id", () => widget.receipient.id);
    postData.putIfAbsent("message", () => message);
    ChatMessage chatMessage = ChatMessage(
        messageContent: message, messageType: MessageType.SENDER.name);
    messages.add(chatMessage);
    _messageController.text = "";
    ApiService.get(_user.token)
        .postData(ApiUrl().sendMessage(), postData)
        .then((value) {
          var statusCode = value["response_code"].toString();
          if (statusCode == "100") {
            setState(() {});
          }
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }
}
