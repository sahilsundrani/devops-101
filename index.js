import express from "express";
import mongoose from "mongoose";
import connectDB from "./config/db.js";

const app = express();
const PORT = process.env.PORT || 3000;

connectDB();
app.use(express.json());

const itemSchema = new mongoose.Schema({
  name: { type: String, required: true },
});
  
const Item = mongoose.model("Item", itemSchema);

app.get("/", (req, res) => {
  console.log("The demo code is working fine");
  return res.status(200).json({ message: true });
});

// Create (POST) - Add an item
app.post("/items", async (req, res) => {
  try {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: "Name is required" });
  
    const newItem = await Item.create({ name });
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
  
// Read (GET) - Get all items
app.get("/items", async (req, res) => {
  try {
    const items = await Item.find();
    res.status(200).json(items);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update (PUT) - Update an item
app.put("/items/:id", async (req, res) => {
  try {
    const { name } = req.body;
    const updatedItem = await Item.findByIdAndUpdate(req.params.id, { name }, { new: true });

    if (!updatedItem) return res.status(404).json({ error: "Item not found" });

    res.status(200).json(updatedItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete (DELETE) - Remove an item
app.delete("/items/:id", async (req, res) => {
  try {
    const deletedItem = await Item.findByIdAndDelete(req.params.id);
    if (!deletedItem) return res.status(404).json({ error: "Item not found" });

    res.status(200).json(deletedItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on port: ${PORT}`);
});