const express = require('express');
const router = express.Router();
const Course = require('../models/Course')
const Lesson = require('../models/Lesson')
const User = require('../models/user')

const sanitizeLesson = async (id, lessons) => {
    if (lessons && Array.isArray(lessons) && lessons.length > 0) {
        await lessons.forEach(async (item) => {
            const result = await Lesson.findOne({ id: item.lesson, is_delete: 0 })
            if (result) {
                await Lesson.findOneAndUpdate({ id: item.lesson, is_delete: 0 }, { $set: { course_id: id } })
            }
        })
    }
}

router.post('/list', async (req, res) => {
    try {
        const {
            author_id,
            is_drafting,
            title
        } = req.body

        let conditions = {}
        if (author_id) conditions.author_id = author_id
        if (!isNaN(is_drafting)) conditions.is_drafting = is_drafting
        if (title) conditions.title = RegExp(title, 'i')

        const data = await Course.find({ is_delete: 0, ...conditions })

        res.status(200).json({ message: 'success', data: data })
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/getById', async (req, res) => {
    try {
        const { id } = req.body

        if (id) {
            const data = await Course.findOne({ id: id, is_delete: 0 })
                .populate({
                    path: 'lessons.lesson.user_id',
                    model: User,
                    localField: 'lessons.lesson.user_id',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
                .populate({
                    path: 'lessons.lesson',
                    model: Lesson,
                    localField: 'lessons.lesson',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
                .populate({
                    path: 'list_subscriber.user_id',
                    model: User,
                    localField: 'list_subscriber.user_id',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
                .populate({
                    path: 'author_id',
                    model: User,
                    localField: 'author_id',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
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

router.post('/create', async (req, res) => {
    try {
        const { title,
            description,
            author_id,
            lessons,
            is_drafting,
            list_subscriber } = req.body

        const maxId = await Course.findOne({ is_delete: 0 }, 'id').sort({ id: -1 })
        const id = maxId ? Number(maxId.id) + 1 : 1

        const newData = new Course({
            id: id,
            title: title ? title : '',
            description: description ? description : '',
            author_id: author_id,
            lessons: lessons ? lessons : [],
            is_delete: 0,
            create_at: new Date(),
            update_at: new Date(),
            user_id: 0, // Chưa có user và login 
            is_drafting: !isNaN(is_drafting) ? is_drafting : 1,
            list_subscriber: list_subscriber ? list_subscriber : [],
        })

        const result = await newData.save();
        await sanitizeLesson(id, lessons)
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
            description,
            author_id,
            lessons,
            is_drafting,
            list_subscriber } = req.body

        const foundData = await Course.findOne({ id: id, is_delete: 0 })
        if (foundData) {
            const update = { update_at: new Date() };
            if (title) update.title = title
            if (description) update.description = description
            if (author_id) update.author_id = author_id
            if (lessons) update.lessons = lessons
            if (!isNaN(is_drafting)) update.is_drafting = is_drafting
            if (list_subscriber) update.list_subscriber = list_subscriber

            await Course.findOneAndUpdate({ id: id, is_delete: 0 }, { $set: update })
            await sanitizeLesson(id, lessons)
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

        const foundData = await Course.findOne({ id: id, is_delete: 0 })
        if (foundData) {
            await Course.findOneAndUpdate({ id: id, is_delete: 0 }, { $set: { is_delete: 1, update_at: new Date() } })
            res.status(200).json({ message: 'delete success' })

        } else {
            res.status(400).json({ message: 'not found' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/subscribe', async (req, res) => {
    try {
        const { id, user_id } = req.body

        if (id && user_id) {
            const foundData = await Course.findOne({ id: id, is_delete: 0, 'list_subscriber.user_id': user_id })
            if (!foundData) {
                // const update = { update_at: new Date() };
                await Course.findOneAndUpdate(
                    { id: id, is_delete: 0 },
                    {
                        $push: { list_subscriber: { user_id: user_id } },
                        $set: { update_at: new Date() }
                    },
                    { upsert: true, new: true }
                )
                res.status(200).json({ message: 'subscribe success' })
            } else {
                res.status(400).json({ message: 'User already subscribed' })
            }
        } else {
            res.status(400).json({ message: 'Missing fields' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/unsubscribe', async (req, res) => {
    try {
        const { id, user_id } = req.body

        if (id && user_id) {
            const foundData = await Course.findOne({ id: id, is_delete: 0, 'list_subscriber.user_id': user_id })
            if (foundData) {
                // const update = { update_at: new Date() };
                await Course.findOneAndUpdate(
                    { id: id, is_delete: 0 },
                    {
                        $pull: { list_subscriber: { user_id: user_id } },
                        $set: { update_at: new Date() }
                    },
                    { new: true }
                )
                res.status(200).json({ message: 'unsubscribe success' })
            } else {
                res.status(400).json({ message: 'User not found' })
            }
        } else {
            res.status(400).json({ message: 'Missing fields' })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

module.exports = router