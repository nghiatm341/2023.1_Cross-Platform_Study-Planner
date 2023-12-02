const express = require("express");
const router = express.Router();
const User = require("../models/user");

router.post("/sign-up", async (req, res) => {
try {
  const { email, firstName, lastName, password, role } = req.body;
  console.log(req.body)
  // const data = await User.find({ email });
  const newData = new User({
    id: 1,
    email,
    firstName,
    lastName,
    password,
    role,
    is_delete: 0,
  });
  const result = await newData.save();
  res.status(200).json({ message: "success", data: result });
} catch (error) {
  console.log("Error", error);
  res.status(500).json({ message: error.message });
}
});

router.get("/list", async (req, res) => {
  try {
    const data = await User.find({ is_delete: 0, role: req.query.role});
    res.status(200).json({ message: "success", data: data });
  } catch (error) {
    console.log("Error", error);
    res.status(500).json({ message: error.message });
  }
});

router.post("/getById", async (req, res) => {
  try {
    const { id } = req.body;

    if (id) {
      const data = await User.findOne({ id: id, is_delete: 0 }).populate({
        path: "lessons.lesson_id",
        model: "Lesson",
        localField: "lessons.lesson_id",
        foreignField: "id",
        option: { lean: true },
      });

      res.status(200).json({ message: "success", data: data });
    } else {
      res.status(400).json({ message: "Thiếu thông tin" });
    }
  } catch (error) {
    console.log("Error", error);
    res.status(500).json({ message: error.message });
  }
});

router.post("/create", async (req, res) => {
  try {
    const { title, description, author_id, lessons } = req.body;

    const maxId = User.findOne({ is_delete: 0 }, "id").sort({ id: -1 });
    const id = Number(maxId.id) + 1 || 1;

    const newData = new User({
      id: id,
      title: title,
      description: description,
      author_id: author_id,
      lessons: lessons ? JSON.parse(lessons) : [],
      is_delete: 0,
      create_at: new Date(),
      update_at: new Date(),
      user_id: 0, // Chưa có user và login
    });

    const result = await newData.save();
    res.status(200).json({ message: "create success", data: result });
  } catch (error) {
    console.log("Error", error);
    res.status(500).json({ message: error.message });
  }
});

router.post("/update", async (req, res) => {
  try {
    const { id, title, description, author_id, lessons } = req.body;

    const foundData = await User.findOne({ id: id, is_delete: 0 });
    if (foundData) {
      const update = { update_at: new Date() };
      if (title) update.title = title;
      if (description) update.description = description;
      if (author_id) update.author_id = author_id;
      if (lessons) update.lessons = JSON.parse(lessons);

      await User.findOneAndUpdate({ id: id, is_delete: 0 }, { $set: { update } });
      res.status(200).json({ message: "update success" });
    } else {
      res.status(400).json({ message: "not found" });
    }
  } catch (error) {
    console.log("Error", error);
    res.status(500).json({ message: error.message });
  }
});

router.post("/delete", async (req, res) => {
  try {
    const { id } = req.body;

    const foundData = await User.findOne({ id: id, is_delete: 0 });
    if (foundData) {
      await User.findOneAndUpdate({ id: id, is_delete: 0 }, { $set: { is_delete: 1, update_at: new Date() } });
      res.status(200).json({ message: "delete success" });
    } else {
      res.status(400).json({ message: "not found" });
    }
  } catch (error) {
    console.log("Error", error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
