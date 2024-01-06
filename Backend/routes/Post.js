const express = require('express')
const router = express.Router();
const Post = require('../models/Post')
const authMiddleware = require('../middlewares/auth.middleware');
const { ROLE } = require('../constant/enum')
const User = require('../models/user')

router.post('/create', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { title, content, image } = req.body
        const user = req.userInfo

        const maxId = await Post.findOne({}, 'id').sort({ id: -1 })
        const id = maxId ? Number(maxId.id) + 1 : 1

        const newData = new Post({
            id: id,

            title: title ? title : "",
            content: content ? content : "",
            image: image ? image : "",
            list_like: [],
            list_comment: [],

            user: user.id,
            is_delete: 0,
            create_at: new Date(),
            update_at: new Date()
        })

        const result = await newData.save()
        res.status(200).json({ message: 'create success', data: result })

    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/update', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { id, title, content, image } = req.body
        const user = req.userInfo

        if (id) {
            const foundData = await Post.findOne({ id: id, is_delete: 0, user: user.id })
            if (foundData) {
                const update = { update_at: new Date() }
                if (title) update.title = title
                if (content) update.content = content
                if (image) update.image = image

                await Post.findOneAndUpdate(
                    { id: id, is_delete: 0, user: user.id },
                    { $set: update }
                )

                res.status(200).json({ message: 'update success' })

            } else {
                res.status(400).json({ message: "Not found" })
            }
        } else {
            res.status(400).json({ message: "Missing id" })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/list', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { user_id } = req.body

        let conditions = { is_delete: 0 }
        if (user_id) conditions.user = user_id

        const data = await Post.find(conditions)
            .sort({ update_at: -1, create_at: -1 })
            .populate({
                path: 'user',
                model: User,
                localField: 'user',
                foreignField: 'id',
                option: { lean: true },
                strictPopulate: false
            })
            .populate({
                path: 'list_like.user',
                model: User,
                localField: 'list_like.user',
                foreignField: 'id',
                option: { lean: true },
                strictPopulate: false
            })
            .populate({
                path: 'list_comment.user',
                model: User,
                localField: 'list_comment.user',
                foreignField: 'id',
                option: { lean: true },
                strictPopulate: false
            })

        res.status(200).json({ message: 'success', data: data })
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/getById', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { id } = req.body

        if (id) {
            const data = await Post.findOne({ id: id })
                .sort({ update_at: -1, create_at: -1 })
                .populate({
                    path: 'user',
                    model: User,
                    localField: 'user',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
                .populate({
                    path: 'list_like.user',
                    model: User,
                    localField: 'list_like.user',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })
                .populate({
                    path: 'list_comment.user',
                    model: User,
                    localField: 'list_comment.user',
                    foreignField: 'id',
                    option: { lean: true },
                    strictPopulate: false
                })

            res.status(200).json({ message: 'success', data: data })

        } else {
            res.status(400).json({ message: "Missing id" })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/delete', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { id } = req.body

        if (id) {
            const foundData = await Post.findOne({ id: id, is_delete: 0 })
            if (foundData) {
                await Post.findOneAndUpdate(
                    { id: id, is_delete: 0 },
                    { $set: { is_delete: 1, update_at: new Date() } }
                )
                res.status(200).json({ message: 'delete success' })
            } else {
                res.status(400).json({ message: "Not found" })
            }
        } else {
            res.status(400).json({ message: "Missing id" })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/likeDislike', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { id } = req.body
        const user = req.userInfo

        if (id) {
            const foundData = await Post.findOne({ id: id, is_delete: 0 })
            if (foundData) {
                let listLike = foundData.list_like
                const index = listLike.findIndex(like => like.user === user.id)

                if (index !== -1) {
                    listLike.splice(index, 1)
                } else {
                    listLike.push({ user: user.id, created_at: new Date() })
                }

                if (listLike.length > 0) {
                    listLike.sort((a, b) => b.created_at - a.created_at)
                }

                await Post.findOneAndUpdate(
                    { id: id, is_delete: 0 },
                    { $set: { list_like: listLike } }
                )

                res.status(200).json({ message: 'toggle like success' })
            } else {
                res.status(400).json({ message: "Not found" })
            }
        } else {
            res.status(400).json({ message: "Missing id" })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

router.post('/comment', authMiddleware.authRoleMiddleware(ROLE.STUDENT, ROLE.TEACHER, ROLE.ADMIN), async (req, res) => {
    try {
        const { id, comment } = req.body
        const user = req.userInfo

        if (id) {
            if (comment) {
                const foundData = await Post.findOne({ id: id, is_delete: 0 })
                if (foundData) {
                    const listComment = foundData.list_comment

                    listComment.push({
                        user: user.id,
                        comment: comment,
                        created_at: new Date()
                    })

                    if (listComment.length > 0) {
                        listComment.sort((a, b) => b.created_at - a.created_at)
                    }

                    await Post.findOneAndUpdate(
                        { id: id, is_delete: 0 },
                        { $set: { list_comment: listComment } }
                    )

                    res.status(200).json({ message: 'comment success' })
                } else {
                    res.status(400).json({ message: "Not found" })
                }
            } else {
                res.status(400).json({ message: "Empty comment" })
            }
        } else {
            res.status(400).json({ message: "Missing id" })
        }
    } catch (error) {
        console.log('Error', error)
        res.status(500).json({ message: error.message })
    }
})

module.exports = router