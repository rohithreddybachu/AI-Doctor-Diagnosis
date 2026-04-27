% -------------------- LIBRARIES --------------------
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).

:- dynamic app_directory/1.
:- dynamic patient/6, diagnosis/3, bill/3, order/6.

:- prolog_load_context(directory, Directory),
   asserta(app_directory(Directory)).

% -------------------- KNOWLEDGE BASE --------------------

symptom(common_cold, runny_nose).
symptom(common_cold, sneezing).
symptom(common_cold, sore_throat).
symptom(common_cold, cough).

symptom(influenza, fever).
symptom(influenza, chills).
symptom(influenza, body_pain).
symptom(influenza, cough).

symptom(fever, high_temperature).
symptom(fever, weakness).
symptom(fever, sweating).
symptom(fever, fever).

symptom(headache, head_pain).
symptom(headache, pressure).
symptom(headache, sensitivity).
symptom(headache, headache).

symptom(acidity, burning_sensation).
symptom(acidity, stomach_discomfort).
symptom(acidity, acidity).

symptom(diarrhea, loose_stools).
symptom(diarrhea, stomach_cramps).
symptom(diarrhea, dehydration).
symptom(diarrhea, diarrhea).

symptom(constipation, hard_stools).
symptom(constipation, bloating).
symptom(constipation, pain).
symptom(constipation, constipation).

symptom(cough, dry_cough).
symptom(cough, wet_cough).
symptom(cough, throat_irritation).
symptom(cough, cough).

symptom(allergy, sneezing).
symptom(allergy, itching).
symptom(allergy, rash).
symptom(allergy, allergy).

symptom(vomiting, nausea).
symptom(vomiting, stomach_upset).
symptom(vomiting, vomiting).

symptom(asthma, wheezing).
symptom(asthma, breathing_difficulty).
symptom(asthma, asthma).

symptom(hypertension, headache).
symptom(hypertension, dizziness).

symptom(diabetes_mellitus, frequent_urination).
symptom(diabetes_mellitus, thirst).
symptom(diabetes_mellitus, excessive_thirst).

symptom(skin_rash, redness).
symptom(skin_rash, itching).
symptom(skin_rash, irritation).
symptom(skin_rash, rash).
symptom(skin_rash, skin_rash).

symptom(migraine, severe_headache).
symptom(migraine, nausea).
symptom(migraine, migraine).

% -------------------- MEDICINES --------------------

medicine(paracetamol, common_cold, "500mg", 27.50).
medicine(oseltamivir, influenza, "75mg", 550.00).
medicine(paracetamol, fever, "500mg", 27.50).
medicine(ibuprofen, headache, "400mg", 50.00).
medicine(pantoprazole, acidity, "40mg", 85.00).
medicine(ors_loperamide, diarrhea, "as directed", 60.00).
medicine(lactulose, constipation, "as directed", 115.00).
medicine(cough_syrup, cough, "as directed", 105.00).
medicine(cetirizine, allergy, "10mg", 40.00).
medicine(ondansetron, vomiting, "4mg", 65.00).
medicine(salbutamol, asthma, "inhaler", 250.00).
medicine(amlodipine, hypertension, "5mg", 50.00).
medicine(metformin, diabetes_mellitus, "500mg", 65.00).
medicine(calamine_lotion, skin_rash, "topical lotion", 105.00).
medicine(sumatriptan, migraine, "50mg", 200.00).

medicine_instruction(metformin, "Use only with medical supervision. Discuss dosing and suitability with a clinician.").
medicine_instruction(amlodipine, "Use only if prescribed for blood pressure care by a clinician.").
medicine_instruction(paracetamol, "Discuss safe dose limits with a clinician or pharmacist. Avoid overdose.").
medicine_instruction(oseltamivir, "Use only if prescribed by a clinician.").
medicine_instruction(ibuprofen, "Avoid if allergic or advised not to use painkillers.").
medicine_instruction(pantoprazole, "Discuss use with a clinician if symptoms continue.").
medicine_instruction(ors_loperamide, "Use ORS for hydration. Seek care for blood, high fever, or dehydration.").
medicine_instruction(lactulose, "Use only as directed. Drink water and seek care if severe pain occurs.").
medicine_instruction(cough_syrup, "Choose medicine based on dry or wet cough after advice.").
medicine_instruction(cetirizine, "May cause drowsiness. Use with pharmacist or clinician advice.").
medicine_instruction(ondansetron, "Seek care if vomiting is repeated or dehydration occurs.").
medicine_instruction(salbutamol, "Breathing difficulty can be urgent. Use only as prescribed.").
medicine_instruction(calamine_lotion, "Apply only externally. Seek care if rash spreads or breathing symptoms appear.").
medicine_instruction(sumatriptan, "Use only if prescribed for migraine by a clinician.").

advice_for(common_cold, "Possible common cold pattern. Rest, fluids, and monitoring may help.").
advice_for(influenza, "Possible influenza pattern. Seek care if fever is high, symptoms worsen, or breathing becomes difficult.").
advice_for(fever, "Possible fever pattern. Monitor temperature and seek care if fever is high or persistent.").
advice_for(headache, "Possible headache pattern. Seek care for severe, sudden, or unusual headache.").
advice_for(acidity, "Possible acidity pattern. Seek care if pain is severe or persistent.").
advice_for(diarrhea, "Possible diarrhea pattern. Hydration is important. Seek care for dehydration, blood, or high fever.").
advice_for(constipation, "Possible constipation pattern. Seek care for severe pain, vomiting, or long-lasting symptoms.").
advice_for(cough, "Possible cough pattern. Seek care for breathing difficulty, chest pain, or persistent cough.").
advice_for(allergy, "Possible allergy pattern. Seek urgent care for swelling of face, lips, or breathing difficulty.").
advice_for(vomiting, "Possible vomiting pattern. Seek care for dehydration or repeated vomiting.").
advice_for(asthma, "Possible asthma pattern. Breathing difficulty can be urgent; seek medical help if severe.").
advice_for(hypertension, "Possible hypertension-related symptom pattern. Blood pressure testing is recommended.").
advice_for(diabetes_mellitus, "Possible diabetes-related symptom pattern. Please consult a clinician for blood sugar testing.").
advice_for(skin_rash, "Possible skin rash pattern. Seek care if rash spreads, becomes painful, or is linked with fever.").
advice_for(migraine, "Possible migraine pattern. Seek care for severe, new, or unusual headache symptoms.").

symptom_alias(shortness_of_breath, shortness_breath).
symptom_alias(breathing_problem, breathing_difficulty).
symptom_alias(breathing_trouble, breathing_difficulty).
symptom_alias(body_ache, body_pain).
symptom_alias(stomach, stomach_discomfort).
symptom_alias(stomach_pain, stomach_cramps).
symptom_alias(stomach_ache, stomach_cramps).
symptom_alias(cold, cough).
symptom_alias(diabetes, thirst).
symptom_alias(frequent_urine, frequent_urination).
symptom_alias(loose_motion, loose_stools).
symptom_alias(loose_motions, loose_stools).
symptom_alias(high_fever, high_temperature).
symptom_alias(temperature, high_temperature).

% -------------------- MAIN FLOW --------------------

consultation :-
    clear_data,
    write('AI Doctor System'), nl,

    write('Enter Name: '), read(Name),
    write('Enter Age: '), read(Age),
    write('Enter Gender (male/female): '), read(Gender),

    write('Enter Symptoms list (example: [fever,cough]): '), nl,
    read(Symptoms),

    assertz(patient(Name, Age, Gender, Symptoms, '', '')),

    diagnose,
    prescribe,
    bill_total.

% -------------------- CLEAR OLD DATA --------------------

clear_data :-
    retractall(patient(_,_,_,_,_,_)),
    retractall(diagnosis(_,_,_)),
    retractall(bill(_,_,_)),
    retractall(order(_,_,_,_,_,_)).

% -------------------- DIAGNOSIS --------------------

diagnose :-
    patient(_,_,_,Symptoms,_,_),
    diagnose_symptoms(Symptoms, Diseases),
    Diseases \= [],
    write('Diagnosis: '), write(Diseases), nl,
    forall(member(D, Diseases),
        assertz(diagnosis(D, Symptoms, confirmed))
    ), !.

diagnose :-
    write('No disease found. Please consult a doctor.'), nl.

diagnose_symptoms(Symptoms, Diseases) :-
    findall(Disease,
        (member(S, Symptoms), canonical_symptom(S, Symptom), symptom(Disease, Symptom)),
        Matches),
    sort(Matches, Diseases).

canonical_symptom(Input, Canonical) :-
    atom(Input),
    normalize_symptom_atom(Input, Normalized),
    ( symptom_alias(Normalized, Canonical) ->
        true
    ;
        Canonical = Normalized
    ).

normalize_symptom_atom(Input, Normalized) :-
    atom_string(Input, InputString),
    normalize_symptom_string(InputString, Normalized).

normalize_symptom_string(Input, Normalized) :-
    string_lower(Input, Lower),
    normalize_space(string(Trimmed), Lower),
    split_string(Trimmed, " -", " \t\n\r", Parts),
    atomic_list_concat(Parts, '_', Normalized).

% -------------------- PRESCRIPTION --------------------

prescribe :-
    diagnosis(Disease,_,_),
    medicine(Med, Disease, Dose, Price),
    format('Medicine: ~w (~w) - Price: ~2f~n', [Med, Dose, Price]),
    assertz(bill(Med, Dose, Price)),
    fail.
prescribe.

medicine_dict(Disease, _{
    disease: Disease,
    name: Med,
    dosage: Dose,
    instruction: Instruction,
    price: Price
}) :-
    medicine(Med, Disease, Dose, Price),
    medicine_instruction(Med, Instruction).

medicines_for(Diseases, Medicines) :-
    findall(Medicine,
        (member(Disease, Diseases), medicine_dict(Disease, Medicine)),
        Medicines).

medicine_total(Medicines, Total) :-
    findall(Price,
        (member(Medicine, Medicines), get_dict(price, Medicine, Price)),
        Prices),
    sum_prices(Prices, Total).

sum_prices([], 0).
sum_prices([H|T], Sum) :-
    sum_prices(T, Rest),
    Sum is H + Rest.

% -------------------- BILL --------------------

bill_total :-
    findall(P, bill(_,_,P), Prices),
    sum_prices(Prices, Total),
    format('Total Bill: ~2f~n', [Total]).

% -------------------- HTTP SERVER --------------------

:- http_handler(root(.), index_handler, []).
:- http_handler(root(api), api_handler, []).
:- http_handler(root(order), order_handler, []).

index_handler(_Request) :-
    app_directory(Directory),
    directory_file_path(Directory, 'index.html', IndexFile),
    reply_file(IndexFile, []).

api_handler(Request) :-
    http_parameters(Request, [
        name(Name, [string]),
        age(Age, [integer]),
        gender(Gender, [string]),
        symptoms(SymptomsText, [string])
    ]),

    symptoms_from_text(SymptomsText, Symptoms),
    diagnose_symptoms(Symptoms, Diseases),
    medicines_for(Diseases, Medicines),
    medicine_total(Medicines, Total),
    advice_text(Diseases, Advice),

    clear_data,
    assertz(patient(Name, Age, Gender, Symptoms, '', '')),
    forall(member(Disease, Diseases),
        assertz(diagnosis(Disease, Symptoms, confirmed))
    ),
    forall(member(Medicine, Medicines),
        (
            get_dict(name, Medicine, MedicineName),
            get_dict(dosage, Medicine, Dosage),
            get_dict(price, Medicine, Price),
            assertz(bill(MedicineName, Dosage, Price))
        )
    ),

    reply_json_dict(_{
        source: prolog,
        patient: Name,
        age: Age,
        gender: Gender,
        symptoms: Symptoms,
        diagnosis: Diseases,
        medicines: Medicines,
        total: Total,
        advice: Advice
    }).

order_handler(Request) :-
    http_parameters(Request, [
        name(Name, [string]),
        phone(Phone, [string]),
        address(Address, [string]),
        total(Total, [float])
    ]),
    get_time(Now),
    OrderNumber is round(Now) mod 100000,
    format(atom(OrderId), '#~|~`0t~d~5+', [OrderNumber]),
    assertz(order(OrderId, Name, Address, Phone, Total, placed)),
    reply_json_dict(_{
        order_id: OrderId,
        patient: Name,
        total: Total,
        address: Address,
        phone: Phone,
        status: placed
    }).

symptoms_from_text(Text, Symptoms) :-
    split_string(Text, ",", " \t\n\r", RawSymptoms),
    exclude(=(""), RawSymptoms, NonEmptySymptoms),
    maplist(normalize_symptom_string, NonEmptySymptoms, NormalizedSymptoms),
    maplist(canonical_symptom, NormalizedSymptoms, Symptoms).

advice_text([], "No disease found. Please consult a licensed doctor.").
advice_text(Diseases, Advice) :-
    findall(Text,
        (member(Disease, Diseases), advice_for(Disease, Text)),
        AdviceParts),
    atomic_list_concat(AdviceParts, " ", Advice).

% -------------------- START SERVER --------------------

start_server :-
    http_server(http_dispatch, [port(8080)]),
    write('Server started at http://localhost:8080'), nl.
