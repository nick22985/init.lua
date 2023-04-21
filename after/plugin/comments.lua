local status, comments = pcall(require, "Comment")

if not status then
    print("Comment is not installed")
    return
end

comments.setup()

