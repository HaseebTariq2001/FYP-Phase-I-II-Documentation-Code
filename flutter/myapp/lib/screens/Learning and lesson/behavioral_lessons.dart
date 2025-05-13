import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Added for notifications

class BehaviorLessonScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const BehaviorLessonScreen({Key? key, this.onComplete}) : super(key: key);
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<BehaviorLessonScreen> {
  final FlutterTts flutterTts = FlutterTts();
  // Added: Instance for local notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int currentIndex = 0;
  double speechRate = 0.5;
  late List<Map<String, String>> screens;
  late String lessonTitle;

  final Map<String, List<Map<String, String>>> lessonContent = {
    'Understanding Emotions': [
      {
        'title': 'Happy Emotion',
        'image': 'assets/images/Happy Emotion.jpeg',
        'text': '''
A happy emotion is a good feeling we get when something nice happens.
We feel happy when we smile, laugh, or enjoy something fun.

How Does Happy Feel in Our Body?

* We smile 😊
* Our eyes shine ✨
* We might laugh or giggle 😄
* Our body feels light and calm

How Can We Make Others Happy?

* Sharing toys
* Giving hugs
* Saying kind words
* Helping a friend''',
      },
      {
        'title': 'Sad Emotion',
        'image': 'assets/images/Sad Emotion.jpeg',
        'text': '''
  Sadness is when you feel down or upset or we miss something we like. It's okay to cry or be quiet when you're sad.

What Makes Us Sad?

* Losing a toy
* Getting hurt
* Someone says mean words
* Missing a friend or family

What Can Help?

* Talking to someone
* Getting a hug
* Taking deep breaths
* Doing something fun
  ''',
      },
      {
        'title': 'Anger Emotion',
        'image': 'assets/images/Angry Emotion.jpeg',
        'text': '''
  Anger is a strong feeling when something bothers us or feels unfair.

What Makes Us Angry?

* Someone takes our toy
* We can’t do what we want
* Someone says “no”
* Loud noises or too much waiting

What Can Help?

* Taking deep breaths
* Counting slowly to 5
* Asking for help
* Taking a break or quiet time
  ''',
      },
      {
        'title': 'Scared Emotion',
        'image': 'assets/images/Scared Emotion.jpeg',
        'text': '''
  Being scared means we feel unsafe or worried.

What Makes Us Scared?

* Loud thunder
* Dark rooms
* Being alone
* New or unknown places

What Can Help?

* Holding someone’s hand
* Turning on a light
* Talking to an adult
* Deep breathing or a hug
  ''',
      },
      {
        'title': 'Curious Emotion',
        'image': 'assets/images/Curious Emotion.jpeg',
        'text': '''
  Curiosity is the feeling we get when we want to know or learn something new.

When Do We Feel Curious?

* Seeing something new
* Asking questions like “Why?” or “How?”
* Exploring toys or books
* Watching animals or machines

What Can We Do?

* Ask safe questions
* Try new things with help
* Look, listen, and learn
* Use books, pictures, or videos
  ''',
      },
    ],
    'Recognizing Behavior': [
      {
        'title': 'What is Behavior?',
        'image': 'assets/images/Recognizing-Behavior.jpeg',
        'text': '''
  Behavior is how we act. It’s what we do with our body, face, and voice.

Examples:

* Smiling when happy 😊
* Jumping when excited 🦘
* Crying when sad 😢
* Shouting when angry 😠
  ''',
      },
      {
        'title': 'Good Behavior',
        'image': 'assets/images/kids-celebrating.jpeg',
        'text': '''
  Good behavior helps us make friends and feel happy.

Examples:

* Sharing toys 🤝
* Saying “please” and “thank you” 🙏
* Listening to adults 👂
* Helping others 🤗
  ''',
      },
      {
        'title': 'Good Behavior',
        'image': 'assets/images/toy-sharing.jpeg',
        'text':
            '''When we share toys, it means letting other people play with some of our things. This helps us make friends and have more fun playing together.''',
      },
      {
        'title': 'Good Behavior',
        'image': 'assets/images/saying-thanks.jpeg',
        'text':
            '''Using the words "please" when we ask for something and "thank you" after someone does something for us are important ways to be polite.''',
      },
      {
        'title': 'Good Behavior',
        'image': 'assets/images/helping-child.jpeg',
        'text':
            '''Helping means doing things to support other people. This can be as simple as picking up something that someone dropped, offering to share a snack, or comforting someone who is sad. When we help others, it makes them feel good and cared for. It also makes us feel good because we are making a positive difference. ''',
      },
      {
        'title': 'Not-Okay Behavior',
        'image': 'assets/images/Angry Emotion.jpeg',
        'text': '''
  Sometimes we show behavior that’s not okay.

Examples:

* Hitting or biting 😠
* Screaming loudly 😤
* Throwing things 😡
* Not listening 🙉

We can learn better ways!
''',
      },
      {
        'title': 'Not-Okay Behavior',
        'image': 'assets/images/child-hitting.jpeg',
        'text': '''
Sometimes, when we feel very upset or don't know how to show our feelings, we might hit or bite. Hitting and biting can hurt other people's bodies and feelings.''',
      },
      {
        'title': 'Not-Okay Behavior',
        'image': 'assets/images/child-screaming.jpeg',
        'text': '''
When we are feeling overwhelmed, frustrated, or very excited, we might scream loudly. While it can help us release big feelings, loud screaming can be startling or upsetting for others.''',
      },
      {
        'title': 'Not-Okay Behavior',
        'image': 'assets/images/child-throwing.jpeg',
        'text': '''
Sometimes, when we are angry or upset, we might want to throw things. Throwing things can be dangerous because things can break or someone can get hurt. It's better to find safer ways to show our anger, like squeezing a soft toy or telling someone how we feel using words.''',
      },
      {
        'title': 'What Can I Do? (Better Choices)',
        'image': 'assets/images/deep-breath.jpeg',
        'text': '''
When big feelings like anger or worry come, try taking slow, deep breaths. Imagine you are smelling a flower and then blowing out a candle. Deep breaths can help your body calm down and make your feelings feel a little bit smaller.
''',
      },
      {
        'title': 'What Can I Do? (Better Choices)',
        'image': 'assets/images/say-angry.jpeg',
        'text': '''
When you feel angry, try using your words to tell someone how you feel. Saying "I feel angry" helps others understand what's happening inside you without scaring or upsetting them with yelling. Using your words is a brave and clear way to communicate your feelings.
''',
      },
      {
        'title': 'What Can I Do? (Better Choices)',
        'image': 'assets/images/walk-away.jpeg',
        'text': '''
If you are feeling very upset and it's hard to calm down in the moment, it can help to walk away to a safe and quiet space. This gives you time to feel your feelings without them getting too big or affecting others. Once you feel calmer, you can decide what to do next.
''',
      },
      {
        'title': 'What Can I Do? (Better Choices)',
        'image': 'assets/images/adult-help.jpeg',
        'text': '''
Grown-ups like parents, teachers, or caregivers are there to help you when you have big feelings or when things feel difficult. If you're feeling angry, sad, or confused, asking a grown-up for help is a strong and smart thing to do. They can offer support and strategies to help you feel better.
''',
      },
    ],
    'Social Cues and Body Language': [
      {
        'title': 'What are Social Cues?',
        'image': 'assets/images/facing-eachother.jpeg',
        'text': '''
Social cues are little signs people use to show how they feel or what they mean.
They can be in faces, hands, voices, or how people stand or move.

Examples of Social Cues:
-Smiling means someone is happy 😊
-A loud voice might mean someone is excited or upset 😠
-Looking away might mean someone is shy or not paying attention 😳
''',
      },
      {
        'title': 'Facial Expressions',
        'image': 'assets/images/multiple-emotions-kids.jpeg',
        'text': '''
Our face can show how we feel without saying a word.

What to Look For:
-Eyes open wide = surprised 😲
-Lips turned down = sad 😢
-Eyebrows pulled in = angry 😠
-Big smile = happy 😄

Why It Matters:
-It helps us understand others and react kindly.
''',
      },
      {
        'title': 'Body Language',
        'image': 'assets/images/body-language.jpeg',
        'text': '''
Our body talks too! This is called body language.

Examples:

-Waving means hello
-Arms crossed might mean someone is upset
-Standing close means someone wants to be friendly
-Turning away can mean they want space
''',
      },
      {
        'title': 'Body Language',
        'image': 'assets/images/Child-Waving.png',
        'text': '''
When someone waves their hand, it's often their way of saying "hello." It's a friendly way to greet someone and let them know you see them. You can wave back to say hello too!
''',
      },
      {
        'title': 'Body Language',
        'image': 'assets/images/upset-kid.jpeg',
        'text': '''
When someone has their arms crossed in front of their body, it can sometimes mean they are feeling upset, closed off, or uncomfortable. It's like they are building a little wall. If you see someone with their arms crossed, they might need some space or a kind question to see if they are okay.
''',
      },
      {
        'title': 'Body Language',
        'image': 'assets/images/walk-away.jpeg',
        'text': '''
When someone turns their body or head away from you, it can be a sign that they want some space or time alone. They might be feeling overwhelmed, tired, or just need a break. It's important to respect their need for space and give them some time.
''',
      },
      {
        'title': 'Eye Contact',
        'image': 'assets/images/eye-contact.jpeg',
        'text': '''
Looking at someone’s eyes when talking is called eye contact.

Why It Helps:

-It shows we are listening
-It makes others feel respected
-It helps us notice how someone feels

Practice Tips:

-Try looking at their nose if eyes feel too strong
-Look away if it feels too much—it’s okay to practice slowly
''',
      },
      {
        'title': 'How to Respond',
        'image': 'assets/images/thumbs-up.jpeg',
        'text': '''
When we notice social cues, we can respond kindly.

Helpful Reactions:

-Smile back 😊
-Say kind words
-Give space if needed
-Ask questions like “Do you want to play?”
''',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    // Added: Initialize notifications when the screen is created
    _initializeNotifications();
  }

  // Added: Initialize the notification plugin for Android
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Added: Send a notification when the lesson is completed
  void _sendLessonCompleteNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'lesson_channel_id', // Channel ID
          'Lesson Notifications', // Channel name
          channelDescription: 'Notifies when a lesson is completed',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Time to Play! 🎮',
      'You’ve completed your lesson! Try the activity ⭐',
      platformChannelSpecifics,
      payload: 'lesson_complete',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    lessonTitle = args?['title'] ?? 'Lesson';
    screens = lessonContent[lessonTitle] ?? [];
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(text);
  }

  void _nextScreen() async {
    await flutterTts.stop();
    if (currentIndex < screens.length - 1) {
      setState(() => currentIndex++);
    } else {
      _showCompletionDialog();
    }
  }

  void _previousScreen() async {
    await flutterTts.stop();
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  void _showCompletionDialog() {
    // Added: Trigger notification before showing dialog
    // Modified: Added 5-second delay for notification while showing dialog immediately
    Future.delayed(Duration(seconds: 5), () {
      _sendLessonCompleteNotification();
    });
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("🎉 Well Done!"),
            content: Text("You’ve completed this lesson."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (widget.onComplete != null) {
                    widget.onComplete!();
                  }
                  Navigator.pop(context);
                  Navigator.pop(context, 'completed');
                },
                child: Text("Continue"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (screens.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Lesson Not Found")),
        body: Center(child: Text("No content available for this lesson.")),
      );
    }

    final screen = screens[currentIndex];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(lessonTitle),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / screens.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                      child: Container(
                        width: screenWidth * 0.4,
                        height: double.infinity,
                        child: Image.asset(
                          screen['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                screen['title']!,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                screen['text']!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _speak(screen['text']!),
              icon: Icon(Icons.volume_up),
              label: Text("Hear This"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Column(
              children: [
                Text(
                  "Adjust Speaking Speed",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: speechRate,
                  min: 0.2,
                  max: 1.0,
                  divisions: 8,
                  label: "${(speechRate * 100).round()}%",
                  onChanged: (value) {
                    setState(() => speechRate = value);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousScreen,
                  child: Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _nextScreen,
                  child: Text(
                    currentIndex == screens.length - 1 ? "Finish" : "Next",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
