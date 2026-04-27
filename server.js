const http = require("http");
const fs = require("fs");
const path = require("path");
const { URL } = require("url");

const PORT = Number(process.env.PORT || 8080);
const ROOT = __dirname;
const PATIENTS_FILE = path.join(ROOT, "patients.json");
const ORDERS_FILE = path.join(ROOT, "orders.json");

const symptomsByDisease = {
  common_cold: ["runny_nose", "sneezing", "sore_throat", "cough"],
  influenza: ["fever", "chills", "body_pain", "cough"],
  fever: ["high_temperature", "weakness", "sweating", "fever"],
  headache: ["head_pain", "pressure", "sensitivity", "headache"],
  acidity: ["burning_sensation", "stomach_discomfort", "acidity"],
  diarrhea: ["loose_stools", "stomach_cramps", "dehydration", "diarrhea"],
  constipation: ["hard_stools", "bloating", "pain", "constipation"],
  cough: ["dry_cough", "wet_cough", "throat_irritation", "cough"],
  allergy: ["sneezing", "itching", "rash", "allergy"],
  vomiting: ["nausea", "stomach_upset", "vomiting"],
  asthma: ["wheezing", "breathing_difficulty", "asthma"],
  hypertension: ["headache", "dizziness"],
  diabetes_mellitus: ["frequent_urination", "thirst", "excessive_thirst"],
  skin_rash: ["redness", "itching", "irritation", "rash", "skin_rash"],
  migraine: ["severe_headache", "nausea", "migraine"]
};

const symptomAliases = {
  shortness_of_breath: "shortness_breath",
  breathing_problem: "breathing_difficulty",
  breathing_trouble: "breathing_difficulty",
  body_ache: "body_pain",
  stomach: "stomach_discomfort",
  stomach_pain: "stomach_cramps",
  stomach_ache: "stomach_cramps",
  stomach_upset: "stomach_upset",
  cold: "cough",
  diabetes: "thirst",
  frequent_urine: "frequent_urination",
  loose_motion: "loose_stools",
  loose_motions: "loose_stools",
  high_fever: "high_temperature",
  temperature: "high_temperature"
};

const medicines = {
  common_cold: {
    disease: "common_cold",
    name: "paracetamol",
    dosage: "500mg",
    instruction: "Use only as directed by a clinician or pharmacist.",
    price: 27.5,
    costRange: "₹15-40"
  },
  influenza: {
    disease: "influenza",
    name: "oseltamivir",
    dosage: "75mg",
    instruction: "Use only if prescribed by a clinician.",
    price: 550,
    costRange: "₹300-800"
  },
  fever: {
    disease: "fever",
    name: "paracetamol",
    dosage: "500mg",
    instruction: "Monitor temperature and avoid overdose.",
    price: 27.5,
    costRange: "₹15-40"
  },
  headache: {
    disease: "headache",
    name: "ibuprofen",
    dosage: "400mg",
    instruction: "Avoid if allergic or advised not to use painkillers.",
    price: 50,
    costRange: "₹20-80"
  },
  acidity: {
    disease: "acidity",
    name: "pantoprazole",
    dosage: "40mg",
    instruction: "Discuss use with a clinician if symptoms continue.",
    price: 85,
    costRange: "₹50-120"
  },
  diarrhea: {
    disease: "diarrhea",
    name: "ORS, loperamide",
    dosage: "as directed",
    instruction: "Use ORS for hydration. Seek care for blood, high fever, or dehydration.",
    price: 60,
    costRange: "₹20-100"
  },
  constipation: {
    disease: "constipation",
    name: "lactulose",
    dosage: "as directed",
    instruction: "Use only as directed. Drink water and seek care if severe pain occurs.",
    price: 115,
    costRange: "₹80-150"
  },
  cough: {
    disease: "cough",
    name: "cough syrup",
    dosage: "as directed",
    instruction: "Choose medicine based on dry or wet cough after advice.",
    price: 105,
    costRange: "₹60-150"
  },
  allergy: {
    disease: "allergy",
    name: "cetirizine",
    dosage: "10mg",
    instruction: "May cause drowsiness. Use with pharmacist or clinician advice.",
    price: 40,
    costRange: "₹20-60"
  },
  vomiting: {
    disease: "vomiting",
    name: "ondansetron",
    dosage: "4mg",
    instruction: "Seek care if vomiting is repeated or dehydration occurs.",
    price: 65,
    costRange: "₹30-100"
  },
  asthma: {
    disease: "asthma",
    name: "salbutamol",
    dosage: "inhaler",
    instruction: "Breathing difficulty can be urgent. Use only as prescribed.",
    price: 250,
    costRange: "₹150-350"
  },
  hypertension: {
    disease: "hypertension",
    name: "amlodipine",
    dosage: "5mg",
    instruction: "Use only if prescribed for blood pressure care by a clinician.",
    price: 50,
    costRange: "₹20-80"
  },
  diabetes_mellitus: {
    disease: "diabetes_mellitus",
    name: "metformin",
    dosage: "500mg",
    instruction: "Use only with medical supervision. Discuss dosing and suitability with a clinician.",
    price: 65,
    costRange: "₹30-100"
  },
  skin_rash: {
    disease: "skin_rash",
    name: "calamine lotion",
    dosage: "topical lotion",
    instruction: "Apply only externally. Seek care if rash spreads or breathing symptoms appear.",
    price: 105,
    costRange: "₹60-150"
  },
  migraine: {
    disease: "migraine",
    name: "sumatriptan",
    dosage: "50mg",
    instruction: "Use only if prescribed for migraine by a clinician.",
    price: 200,
    costRange: "₹100-300"
  }
};

const advice = {
  common_cold: "Possible common cold pattern. Rest, fluids, and monitoring may help.",
  influenza: "Possible influenza pattern. Seek care if fever is high, symptoms worsen, or breathing becomes difficult.",
  fever: "Possible fever pattern. Monitor temperature and seek care if fever is high or persistent.",
  headache: "Possible headache pattern. Seek care for severe, sudden, or unusual headache.",
  acidity: "Possible acidity pattern. Seek care if pain is severe or persistent.",
  diarrhea: "Possible diarrhea pattern. Hydration is important. Seek care for dehydration, blood, or high fever.",
  constipation: "Possible constipation pattern. Seek care for severe pain, vomiting, or long-lasting symptoms.",
  cough: "Possible cough pattern. Seek care for breathing difficulty, chest pain, or persistent cough.",
  allergy: "Possible allergy pattern. Seek urgent care for swelling of face, lips, or breathing difficulty.",
  vomiting: "Possible vomiting pattern. Seek care for dehydration or repeated vomiting.",
  asthma: "Possible asthma pattern. Breathing difficulty can be urgent; seek medical help if severe.",
  hypertension: "Possible hypertension-related symptom pattern. Blood pressure testing is recommended.",
  diabetes_mellitus: "Possible diabetes-related symptom pattern. Please consult a clinician for blood sugar testing.",
  skin_rash: "Possible skin rash pattern. Seek care if rash spreads, becomes painful, or is linked with fever.",
  migraine: "Possible migraine pattern. Seek care for severe, new, or unusual headache symptoms."
};

function readJsonFile(filePath) {
  if (!fs.existsSync(filePath)) {
    return [];
  }

  try {
    const content = fs.readFileSync(filePath, "utf8");
    return content.trim() ? JSON.parse(content) : [];
  } catch (error) {
    console.error(`Could not read ${path.basename(filePath)}:`, error.message);
    return [];
  }
}

function writeJsonFile(filePath, data) {
  fs.writeFileSync(filePath, `${JSON.stringify(data, null, 2)}\n`, "utf8");
}

function appendJsonRecord(filePath, record) {
  const records = readJsonFile(filePath);
  records.push(record);
  writeJsonFile(filePath, records);
}

function createId(prefix) {
  return `${prefix}-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
}

function normalizeSymptom(input) {
  const normalized = String(input)
    .trim()
    .toLowerCase()
    .replace(/[-\s]+/g, "_");

  return symptomAliases[normalized] || normalized;
}

function parseSymptoms(text) {
  return String(text || "")
    .replace(/\band\b/gi, ",")
    .split(/[,;]+/)
    .map(normalizeSymptom)
    .filter(Boolean);
}

function diagnose(symptoms) {
  const scoredMatches = [];

  for (const [disease, diseaseSymptoms] of Object.entries(symptomsByDisease)) {
    const score = symptoms.filter((symptom) => diseaseSymptoms.includes(symptom)).length;
    if (score > 0) {
      scoredMatches.push({ disease, score });
    }
  }

  if (scoredMatches.length === 0) {
    return [];
  }

  const bestScore = Math.max(...scoredMatches.map((match) => match.score));
  return scoredMatches
    .filter((match) => match.score === bestScore)
    .map((match) => match.disease)
    .sort();
}

function sendJson(response, statusCode, data) {
  response.writeHead(statusCode, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store"
  });
  response.end(JSON.stringify(data));
}

function sendFile(response, filePath, contentType) {
  fs.readFile(filePath, (error, data) => {
    if (error) {
      response.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" });
      response.end("Not found");
      return;
    }

    response.writeHead(200, {
      "Content-Type": contentType,
      "Cache-Control": "no-store"
    });
    response.end(data);
  });
}

function handleApi(requestUrl, response) {
  const name = requestUrl.searchParams.get("name") || "";
  const age = Number(requestUrl.searchParams.get("age") || 0);
  const gender = requestUrl.searchParams.get("gender") || "";
  const symptomsText = requestUrl.searchParams.get("symptoms") || "";
  const symptoms = parseSymptoms(symptomsText);
  const diagnosis = diagnose(symptoms);
  const medicineList = diagnosis.map((disease) => medicines[disease]).filter(Boolean);
  const total = medicineList.reduce((sum, medicine) => sum + medicine.price, 0);
  const adviceText = diagnosis.length
    ? diagnosis.map((disease) => advice[disease]).join(" ")
    : "No disease found. Please consult a licensed doctor.";
  const patientRecord = {
    patient_id: createId("PAT"),
    created_at: new Date().toISOString(),
    name,
    age,
    sex: gender,
    gender,
    symptoms_text: symptomsText,
    symptoms,
    diagnosis,
    medicines: medicineList,
    total,
    advice: adviceText
  };

  appendJsonRecord(PATIENTS_FILE, patientRecord);

  sendJson(response, 200, {
    source: "node",
    patient_id: patientRecord.patient_id,
    patient: name,
    age,
    gender,
    symptoms,
    diagnosis,
    medicines: medicineList,
    total,
    advice: adviceText
  });
}

function handleOrder(requestUrl, response) {
  const paymentMethod = requestUrl.searchParams.get("paymentMethod") || "not_selected";
  const payment = {
    method: paymentMethod,
    label: requestUrl.searchParams.get("paymentLabel") || paymentMethod,
    reference: requestUrl.searchParams.get("paymentReference") || "",
    status: paymentMethod === "cod" ? "pending_on_delivery" : "selected"
  };

  const order = {
    order_id: `#${String(Date.now() % 100000).padStart(5, "0")}`,
    created_at: new Date().toISOString(),
    patient: requestUrl.searchParams.get("name") || "",
    total: Number(requestUrl.searchParams.get("total") || 0),
    address: requestUrl.searchParams.get("address") || "",
    phone: requestUrl.searchParams.get("phone") || "",
    payment,
    status: "placed"
  };

  appendJsonRecord(ORDERS_FILE, order);
  sendJson(response, 200, order);
}

function handlePatients(response) {
  sendJson(response, 200, readJsonFile(PATIENTS_FILE));
}

function handleOrders(response) {
  sendJson(response, 200, readJsonFile(ORDERS_FILE));
}

const server = http.createServer((request, response) => {
  const requestUrl = new URL(request.url, `http://${request.headers.host}`);

  if (requestUrl.pathname === "/" || requestUrl.pathname === "/index.html") {
    sendFile(response, path.join(ROOT, "index.html"), "text/html; charset=utf-8");
    return;
  }

  if (requestUrl.pathname === "/api") {
    handleApi(requestUrl, response);
    return;
  }

  if (requestUrl.pathname === "/order") {
    handleOrder(requestUrl, response);
    return;
  }

  if (requestUrl.pathname === "/patients") {
    handlePatients(response);
    return;
  }

  if (requestUrl.pathname === "/orders") {
    handleOrders(response);
    return;
  }

  response.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" });
  response.end("Not found");
});

function listen(port) {
  server.listen(port, () => {
    console.log(`Server started at http://localhost:${port}`);
  });
}

server.on("error", (error) => {
  if (error.code === "EADDRINUSE" && PORT === 8080) {
    console.log("Port 8080 is already in use. Trying http://localhost:8081 instead.");
    listen(8081);
    return;
  }

  throw error;
});

listen(PORT);
