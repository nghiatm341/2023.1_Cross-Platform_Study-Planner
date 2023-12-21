const express = require('express');
const router = express.Router();
const Lesson = require('../models/Lesson')
const User = require('../models/user')
// const dayjs = require('dayjs')

// get list by course id
router.post('/getByCourse', async (req, res) => {
    try {
        const { course_id } = req.body;
        if (course_id) {
            const data = await Lesson.find({ course_id: course_id, is_delete: 0 }).sort({ lesson_before_id: 1, id: 1 })

            res.status(200).json({ message: 'success', data: data })
        } else {
            res.status(400).json({ message: 'Thiếu thông tin' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

// get by id
router.post('/getById', async (req, res) => {
    try {
        const { id } = req.body;
        if (id) {
            const data = await Lesson.findOne({ id: id, is_delete: 0 })
            .populate({
                path: 'user_id',
                model: User,
                localField: 'user_id',
                foreignField: 'id',
                option: { lean: true },
                strictPopulate: false
            })

            res.status(200).json({ message: 'success', data: data })
        } else {
            res.status(400).json({ message: 'Thiếu thông tin' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

// create
router.post('/create', async (req, res) => {
    try {
        const { title,
            contents,
            chapter_title,
            course_id,
            estimate_time,
            lesson_before_id
        } = req.body

        const maxId = await Lesson.findOne({ is_delete: 0 }, 'id').sort({ id: -1 })
        const lastId = await Lesson.findOne({ is_delete: 0, course_id: course_id }, 'id').sort({ id: -1 })
        const id = maxId ? Number(maxId.id) + 1 : 1

        const newLesson = new Lesson({
            id: id,

            title: title,
            contents: contents,
            chapter_title: chapter_title,
            course_id: course_id,
            estimate_time: estimate_time,
            lesson_before_id: lastId ? lastId.id : 0,

            is_delete: 0,
            create_at: new Date(),
            update_at: new Date(),
            user_id: 0, // Chưa có user và login 
        })

        const result = await newLesson.save();
        res.status(200).json({ message: 'create success', data: result })

    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/update', async (req, res) => {
    try {
        const { id,
            title,
            contents,
            chapter_title,
            course_id,
            estimate_time,
            lesson_before_id } = req.body

        const foundData = await Lesson.findOne({ id: id, is_delete: 0 })
        if (foundData) {
            const update = { update_at: new Date() };
            if (title) update.title = title
            if (contents) update.contents = contents
            if (chapter_title) update.chapter_title = chapter_title
            if (course_id) update.course_id = course_id
            if (estimate_time) update.estimate_time = estimate_time
            if (lesson_before_id) update.lesson_before_id = lesson_before_id

            await Lesson.updateOne({ id: id, is_delete: 0 }, { $set: update })
            res.status(200).json({ message: 'update success' })

        } else {
            res.status(400).json({ message: 'not found' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/delete', async (req, res) => {
    try {
        const { id } = req.body

        const foundData = await Lesson.findOne({ id: id, is_delete: 0 })
        if (foundData) {
            await Lesson.findOneAndUpdate({ id: id, is_delete: 0 }, { $set: { is_delete: 1, update_at: new Date() } })
            res.status(200).json({ message: 'delete success' })

        } else {
            res.status(400).json({ message: 'not found' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

module.exports = router