import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comment:${topicId}`, {})
  let commentBtn = document.querySelector("#comment-btn")
  let commentContent = document.querySelector("#comment-content")

  if(commentBtn !== null) {
    commentBtn.addEventListener("click", () => {
      channel.push("comment:add", { content: commentContent.value })
    })
  }

  // Render initial comments (all)
  function renderComments(comments) {
    const renderedComments = comments.map(comment => {
      return commentTemplate(comment)
    })

    document.querySelector(".collection").innerHTML = renderedComments.join("")
  }

  // render new single comment
  function renderComment(event) {
    const renderedComment = commentTemplate(event.comment)

    document.querySelector(".collection").innerHTML += renderedComment
  }

  function commentTemplate(comment) {
    let email = "Anonymous"

    if(comment.user) {
      email = comment.user.email
    }

    return `
      <li class="collection-item">
        <b>${email}</b>: ${comment.content}
      </li>
    ` 
  }

  // Whenever the channel receive new event from broadcast, call renderComment function
  channel.on(`comment:${topicId}:new`, renderComment)

  // Client join()
  channel.join()
    .receive("ok", resp => { renderComments(resp.comments) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}

window.createSocket = createSocket
