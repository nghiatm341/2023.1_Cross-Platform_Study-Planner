const express = require('express');
const router = express.Router();
const Lesson = require('../models/Lesson')
const dayjs = require('dayjs')

// get list by course id
router.post('/getByCourse', async (req, res) => {
    try {
        const { course_id } = req.body;
        if (course_id) {
            const data = Lesson.find({ course_id: course_id, is_delete: 0 }).sort({ lesson_before_id: 1, id: 1 })

            res.status(200).json({ data: data })
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
            const data = Lesson.findOne({ id: id, is_delete: 0 })

            res.status(200).json({data: data})
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
        const {title,
            content,
            chapter_title,
            course_id,
            estimate_time,
            lesson_before_id} = req.body
        
        const maxId = Lesson.findOne({}, 'id').sort({id: -1})
        const id = Number(maxId) + 1 || 1

    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})