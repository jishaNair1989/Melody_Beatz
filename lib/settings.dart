import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:musiq_player/db/functions/db_playlist.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

_sendingMails() async {
  var url = Uri.parse("mailto:jpn4uuu@gmail.com");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

_sendingSMS() async {
  var url = Uri.parse("sms:9048690016");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black54,
        ),
        title: const Text(
          'S E T T I N G S',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Lottie.asset('assets/images/settings.json', height: 150),
            const ListTile(
              leading: Text(
                'C O M M U N I C A T I O N',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.mail_outline,
                color: Colors.black54,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          title: Text('Mail @ jpn4uuu@gmail.com'),
                        ));
                // Text('Mobile:9557863208'),
                // Text('Mail:gfg@gmail.com'),
              },
              title: const Text('CONTACT US',style: TextStyle(fontSize: 14),),
            ),
            ListTile(
              leading: const Icon(
                Icons.feedback_outlined,
                color: Colors.black54,
              ),
              title: const Text('FEEDBACK'),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: ListTile(
                            leading: ElevatedButton(
                                onPressed: () {
                                  _sendingMails();
                                },
                                child: Text('MAIL')),
                            title: ElevatedButton(
                                onPressed: () {
                                  _sendingSMS();
                                },
                                child: Text(
                                  'MESSAGE',
                                  maxLines: 1,
                                ))),
                      );
                    });
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              leading: Text(
                'I N F O',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Colors.black54,
              ),
              onTap: () {
                // showDialog(
                //     context: context,
                //     builder: (context) => AlertDialog(
                //       title:ListView (
                //           children:[ Text("")],),));
              },
              title: Text('PRIVACY POLICY'),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.black54,
              ),
              title: const Text('RESET APP'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: RichText(
                      text: const TextSpan(
                        text: 'R',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontFamily:'KaushanScript'
                        ),
                        children: [
                          TextSpan(
                            text: 'ESET',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    content:
                        const Text('Are you sure you want to reset your app?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL')),
                      TextButton(
                          onPressed: () {
                            appReset(context);
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK')),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              onTap: () async {},
              leading: const Icon(
                Icons.share_outlined,
                color: Colors.black54,
              ),
              title: const Text('SHARE'),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.black54,
              ),
              title: const Text('ABOUT'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Melody_Beatz',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2022 Melody_Beatz',
                );
              },
            ),
            const SizedBox(
              height: 0,
            ),
            const Center(
              child: Text(
                'v.1.0.0',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
