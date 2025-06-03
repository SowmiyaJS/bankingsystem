import express from "express";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DATA_FILE = path.join(__dirname, "data", "database.json");

app.use(express.json());
app.use(express.static("public"));

// Load or initialize data
const loadData = () => {
  if (!fs.existsSync(DATA_FILE)) return {};
  return JSON.parse(fs.readFileSync(DATA_FILE));
};

const saveData = (data) => {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
};

app.post("/create", (req, res) => {
  const { username } = req.body;
  const data = loadData();
  if (data[username]) return res.status(400).json({ error: "Account exists" });
  data[username] = { balance: 0 };
  saveData(data);
  res.json({ status: "Account created" });
});

app.post("/deposit", (req, res) => {
  const { username, amount } = req.body;
  const data = loadData();
  if (!data[username]) return res.status(404).json({ error: "No account" });
  data[username].balance += Number(amount);
  saveData(data);
  res.json({ status: "Deposit successful" });
});

app.post("/withdraw", (req, res) => {
  const { username, amount } = req.body;
  const data = loadData();
  if (!data[username]) return res.status(404).json({ error: "No account" });
  if (data[username].balance < amount)
    return res.status(400).json({ error: "Insufficient funds" });
  data[username].balance -= Number(amount);
  saveData(data);
  res.json({ status: "Withdrawal successful" });
});

app.get("/balance/:username", (req, res) => {
  const data = loadData();
  const user = data[req.params.username];
  if (!user) return res.status(404).json({ error: "No account" });
  res.json({ balance: user.balance });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Banking app running on http://0.0.0.0:${PORT}`);
});
