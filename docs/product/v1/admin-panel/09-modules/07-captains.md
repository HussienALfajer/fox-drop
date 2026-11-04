# 9.7 Captains «الكباتن»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

## 9.7.1 Application pipeline «طلبات الانضمام»

The pipeline is a board or list by stage:

«جديد» (new) → «قيد المراجعة» (under review) → «مقابلة وتدريب» (interview and training) → «بانتظار العدة» (awaiting kit) → «مفعّل» (active, on probation)

Two side stages: «مرفوض» (rejected) and «قائمة انتظار» (waitlist).

**Application review page:**

- Applicant data: full three-part name, phone (verified), date of birth (`captain.min_age` 18), neighbourhood, vehicle type (motorbike, car, bicycle or e-bike, walking), plate number for motor vehicles.
- **Documents (D24).** Each document has its file(s), number (where relevant), issue date, an optional expiry date, a status («بانتظار التحقق» pending, «مقبول» accepted, «مرفوض» rejected with a reason) and who verified it.

  | Document                    | Arabic          | Required                                                                                                   |
  | --------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------- |
  | National ID, front and back | «الهوية»        | Yes                                                                                                        |
  | Personal photo              | «صورة شخصية»    | Yes                                                                                                        |
  | Civil registry extract      | «إخراج قيد»     | Yes                                                                                                        |
  | Criminal record certificate | «لا حكم عليه»   | Yes. Valid `captain.criminal_record_validity_months` (12) from its issue date, which sets its expiry date. |
  | Vehicle papers              | «أوراق المركبة» | Yes for motor vehicles (licensed vehicles only)                                                            |
  | Driving licence             | «شهادة قيادة»   | Optional                                                                                                   |
  | Signed contract             | «العقد الموقّع» | Yes, before activation                                                                                     |

- Applicants upload documents from the captain app. The office can also upload paper scans from the panel.
- **Duplicate check:** an automatic warning appears if the ID number, phone or plate is already registered to another captain or applicant.
- Reviewer notes and the stage history.
- **Re-applying:** a rejected applicant can apply again after 30 days (fixed). A former captain flagged «خروج مبكر» can apply, and the duplicate check shows the flag. Their activation needs OWN's approval (captain-app spec C17).

**Pipeline actions:**

| Action                                       | Effect                                                                                                                                                                                                                | Who                                       |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| Request a document or correction «طلب مستند» | The applicant is notified of what is missing                                                                                                                                                                          | OPS, OWN                                  |
| Schedule an interview «تحديد مقابلة»         | Date and time sent to the applicant                                                                                                                                                                                   | OPS, OWN                                  |
| Record training and test passed              | Moves the application to «بانتظار العدة»                                                                                                                                                                              | OPS, OWN                                  |
| Issue the kit «تسليم العدة»                  | Items (thermal bag, vest, sizes)                                                                                                                                                                                      | OPS, OWN                                  |
| Record the deposit                           | Paid in full or in instalments (deducted on Thursdays); receipt                                                                                                                                                       | FIN, OWN                                  |
| Set the cash limit                           | Required before activation (D10)                                                                                                                                                                                      | FIN, OWN                                  |
| Record the contract                          | Signing date and scan; computes probation and commitment dates (§9.7.2)                                                                                                                                               | OPS, OWN                                  |
| Activate «تفعيل»                             | Needs: required documents accepted, training passed, kit issued, deposit recorded, contract signed, vehicle set, cash limit set, and OWN's approval for a captain flagged «خروج مبكر». The captain can now go online. | OPS, OWN (OWN only for a flagged captain) |
| Reject «رفض»                                 | With a reason that is sent to the applicant                                                                                                                                                                           | OPS, OWN                                  |
| Waitlist «قائمة انتظار»                      | For when no captains are needed now; the applicant is told                                                                                                                                                            | OPS, OWN                                  |

## 9.7.2 Contract «العقد» (D24)

- **Fields:**
  - signing date and start date
  - probation length `captain.probation_days` (30)
  - minimum commitment after probation `captain.min_commitment_months` (3)
  - computed: probation end date and commitment end date
  - contract scan
- **Contract phases:** «فترة تجربة» (probation) → «فترة التزام» (commitment) → «مفتوح» (open-ended after the commitment period). Each phase is shown on the captain's profile and in the captain app.
- **Phase changes:**
  - Probation → commitment needs OPS confirmation (below).
  - Commitment → open-ended happens automatically on the commitment end date.
  - Each phase change notifies the captain.
- **Probation review:**
  - `captain.probation_review_notice_days` (3) days before probation ends, OPS gets a task.
  - OPS either confirms, which moves the captain to the commitment period, or ends the contract, which starts offboarding.
  - If probation ends without a review, the captain keeps working, stays in «فترة تجربة» and the task turns into a warning for OWN and OPS until someone decides. The commitment period starts from the confirmation date.
- **Early exit (captain-app spec C17):** ending during the commitment period sets the flag «خروج مبكر».
  - There is no financial penalty in V1.
  - The kit must be returned. If it is not, the deposit is withheld in the offboarding checklist (§9.7.5).
  - A flagged captain can be rehired only with OWN's approval (§9.7.1).

## 9.7.3 Captain list

- **Columns:**
  - name, phone, vehicle
  - status: «متصل متاح» (online, available), «مشغول» (busy), «غير متصل» (offline), «موقوف» (suspended), «محجوب لعدم تسليم النقد» (blocked for unhanded cash)
  - contract phase
  - custody (base equivalent) and limit-usage bar
  - earnings balance
  - orders today
  - acceptance rate (last 50 offers)
  - rating
- **Filters and sorting:** by any column, for example highest custody first.

## 9.7.4 Captain profile (tabs)

- «نظرة عامة» (overview): orders, acceptance rate, cancellations, on-time rate, rating, earnings for the week and month, and online hours.
- «البيانات والمستندات» (data and documents): with document status, expiry and replacement. `captain.document_expiry_notice_days` (30) before expiry, OPS gets a task.
- «التطبيق» (app):
  - the captain's maximum pickup amount and carried currencies, set by the captain (captain-app spec §10.5)
  - the signed-in device, its app version and its last device-check result
  - the count of consecutive expired offers
- «المركبة» (vehicle).
- «العقد» (contract) (§9.7.2).
- «العدة والتأمين» (kit and deposit): items issued, deposit paid, instalments remaining, items returned.
- «العهدة» (custody): balance per currency with its base equivalent, `closed_due` (due from closed days) shown apart from today's custody (§8.5.4), the entries list, the hand-in status and any grace.
- «المستحقات» (earnings): balance, entries, and weekly statements.
- «الطلبات» (orders) and «سجل العروض» (offer log): every offer with the time, the order, the response (accepted, rejected or expired) and the response time.
- «التقييمات والشكاوى» (ratings and complaints), «المخالفات والإيقافات» (violations and suspensions), «ملاحظات» (notes) and «سجل التغييرات» (change log).

## 9.7.5 Captain actions

| Action                            | Detail                                                                                                                                                                                                                | Who                                                     | Reason   |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- | -------- |
| Suspend «إيقاف»                   | For a duration or until further notice. The reason is shown to the captain in the app.                                                                                                                                | OWN, OPS                                                | Required |
| Reactivate                        | Ends a suspension                                                                                                                                                                                                     | OWN, OPS                                                | Required |
| Force offline «فصل من الاتصال»    | Sets the captain offline immediately. With an active order, the captain enters last-order mode instead: tracking continues, and they go offline when the order ends. A suspension during an order works the same way. | OWN, OPS                                                | Required |
| Release the device «تحرير الجهاز» | Signs out the captain's current device, so they can sign in on another phone, including during an active order (captain-app spec §4.9)                                                                                | OWN, OPS                                                | Required |
| Change the cash limit             | New value, effective immediately                                                                                                                                                                                      | OWN, FIN                                                | Required |
| Hand-in grace                     | Lifts the daily hand-in block until the next cutoff; the custody stays due (§8.5.4)                                                                                                                                   | OWN, FIN                                                | Required |
| Message or push                   | A direct notification to the captain                                                                                                                                                                                  | OWN, OPS                                                | —        |
| Record a violation                | Pick the type; the system suggests the next ladder step (§9.7.6); the admin confirms; the captain sees it. The captain's «اعتراض» in the app opens a ticket, and its result is recorded on the violation.             | OWN, OPS                                                | Required |
| Terminate «إنهاء التعاقد»         | Offboarding checklist (below)                                                                                                                                                                                         | OWN, OPS start it; the money steps follow the checklist | Required |

**Offboarding checklist:**

1. Kit returned (OPS).
2. Custody zero in every currency (FIN or OWN at the desk).
3. Earnings settled: by FIN in the Thursday settlement, or by OWN as an off-cycle payout on any other day.
4. Deposit refunded or withheld according to the contract (FIN or OWN).
5. Account closed. The captain can no longer go online.

## 9.7.6 Performance and violations

- **Acceptance rate:**
  - It is calculated over the last `captain.acceptance_window_offers` (50) offers.
  - Below `captain.acceptance_alert_pct` (70%) the captain gets a warning in the app.
  - Below `captain.acceptance_review_pct` (50%) OPS gets a review task.
  - There is no automatic suspension in V1.
- **Conduct ladder:**
  1. «تنبيه» (warning)
  2. «إيقاف يوم» (1-day suspension)
  3. «إيقاف 7 أيام» (7-day suspension)
  4. «إنهاء التعاقد» (termination)

  Violations count within `captain.violation_window_days` (90). Severe violations (theft, harassment, violence) mean immediate termination. The system suggests the step and the admin decides.

- **Cancellation after acceptance:** a captain who cannot complete an accepted order presses «لا أستطيع إكمال الطلب» with a reason, which raises «كابتن لا يستطيع إكمال الطلب» (§9.1.3). The order stays with the captain until OPS reassign it (before pickup) or hand it over (after pickup) (§9.3.2). It is logged as a captain cancellation, unless OPS marks it as not the captain's fault.
- **Automatic offline:** after `captain.offer_expiry_offline_count` (3) offers in a row expire without an answer, the captain is set offline automatically (captain-app spec §7.4). Expired offers also count in the acceptance rate.
