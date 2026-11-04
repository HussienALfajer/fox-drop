# 5. Joining

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 5.1 Entry screen

A person who is not signed in sees two buttons:

- «انضم ككابتن» (join as a captain)
- «تسجيل الدخول» (sign in)

Both start with the phone number and a code (§4.9). After the code is verified:

- **No account:** the application form opens. A draft is saved after every step.
- **An application in progress:** the application status page opens (§5.4).
- **An active captain:** the home screen opens.

## 5.2 Application form

| Step | Fields |
|---|---|
| 1. Personal | Full three-part name, date of birth (at least `captain.min_age` (18)), neighbourhood |
| 2. Vehicle | Type: «دراجة نارية» (motorbike), «سيارة» (car), «دراجة هوائية أو كهربائية» (bicycle or e-bike), «مشياً» (walking). For motor vehicles: plate number and vehicle papers. Only licensed vehicles are accepted. |
| 3. Documents | §5.3 |
| 4. Terms | The captain terms and the work rules, with a required checkbox |
| 5. Review and send | A summary, then «إرسال الطلب» |

- Phone numbers are validated as Syrian or Turkish mobile numbers.
- The server runs the duplicate check on the ID number, phone and plate (AP §9.7.1). The applicant does not see the result.

## 5.3 Documents (AP D24)

| Document | Arabic | Required | How |
|---|---|---|---|
| National ID, front and back | «الهوية» | Yes | Camera, with a guide frame |
| Personal photo | «صورة شخصية» | Yes | Front camera, plain background, no sunglasses |
| Civil registry extract | «إخراج قيد» | Yes | Camera or a file |
| Criminal record certificate | «لا حكم عليه» | Yes; valid for 12 months from its issue date (C18) | Camera or a file, with the issue date |
| Vehicle papers | «أوراق المركبة» | Yes for motor vehicles | Camera |
| Driving licence | «شهادة قيادة» | Optional | Camera |

- **Quality checks:** the app checks each photo for blur and darkness before upload, and asks for a retake when it fails.
- **Status:** each document shows «بانتظار التحقق» (pending), «مقبول» (accepted) or «مرفوض» (rejected) with the reason. A rejected document can be uploaded again.
- **Signed contract:** signed at the office and uploaded by staff (AP §9.7.1). It is not uploaded from the app.

## 5.4 Application status

The status page shows the current stage, what the applicant needs to do, and the history. The applicant gets a push at every change.

| Panel stage (AP §9.7.1) | What the applicant sees |
|---|---|
| «جديد» | «أُرسل طلبك. سنراجعه قريباً.» |
| «قيد المراجعة» | «طلبك قيد المراجعة.» Plus any document requested: «يرجى رفع {المستند}: {السبب}» |
| «مقابلة وتدريب» | «موعد المقابلة والتدريب: {اليوم} {الساعة} في {المكان}», with the office on a map |
| «بانتظار العدة» | «اجتزت التدريب. استلم العدة ووقّع العقد في المكتب.» |
| «مفعّل» | «مرحباً بك في FOX DROP!», and the app moves to the home screen |
| «قائمة انتظار» (waitlist) | «لا نحتاج كباتن جدداً حالياً. طلبك محفوظ وسنتواصل معك.» |
| «مرفوض» | «نعتذر، لم يُقبل طلبك: {السبب}. يمكنك التقديم مجدداً بعد {التاريخ}.» A rejected applicant can apply again after 30 days (K11, fixed). |

A former captain flagged «خروج مبكر» can apply again, but activation needs OWN's approval (C17, AP §9.7.1).

## 5.5 Activation

The panel activates the captain when everything in AP §9.7.1 is done: documents accepted, training passed, kit issued, deposit recorded, contract signed, vehicle set and cash limit set. On activation:

- the app shows a short welcome tour: going online, an offer, an order, custody and earnings
- the device check runs (§4.5)
- the app asks for «أقصى مبلغ أحمله» and «العملات التي أحملها» (§10.5)
