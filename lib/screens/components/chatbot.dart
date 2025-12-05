import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatbotController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  TextEditingController userInputController = TextEditingController();
  RxBool showChatbot = false.obs;

  Future<void> sendMessage() async {
    final userInput = userInputController.text.trim();
    if (userInput.isEmpty) return;

    try {
      final uri = Uri.parse('https://chatgpt4-api.p.rapidapi.com/gpt').replace(queryParameters: {
        'content': userInput,
      });

      final response = await http.get(
        uri,
        headers: {
          'X-RapidAPI-Key': 'a94323418amsh783509162229c73p144890jsncabe996d2c6f',
          'X-RapidAPI-Host': 'chatgpt4-api.p.rapidapi.com',
        },
      );

      print(response.statusCode);

      messages.add({'content': userInput, 'isUserMessage': true});
      messages.add({'content': response.body, 'isUserMessage': false});
      userInputController.clear();
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  void toggleChatbot() {
    showChatbot.toggle();
  }

  @override
  void onClose() {
    super.onClose();
    userInputController.dispose();
  }
}

class ChatbotScreen extends StatelessWidget {
  final ChatbotController controller = Get.put(ChatbotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return ListTile(
                    title:Container(
                      
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],),child: 
 Text(message["content"]),),
                   
                    leading: message['isUserMessage']
                        ? Icon(Icons.person)
                        : Icon(Icons.chat_bubble),
                  );
                },
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child:  Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          controller: controller.userInputController,
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),))))])
                  ),),),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: controller.sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
