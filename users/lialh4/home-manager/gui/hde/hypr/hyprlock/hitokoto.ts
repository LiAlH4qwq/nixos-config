const main = async () => {
    const fallback = {
        hitokoto: "数人世相逢，百年欢笑，能得几回又。",
        from: "摸鱼儿·记年时人人何处",
        from_who: "何梦桂"
    }
    const timeout = Bun.sleep(3 * 1000).then(_ => fallback)
    const online = await fetch("https://v1.hitokoto.cn/?c=i")
        .then(res => res.json())
        .then(res => {
            if (typeof res != "object") throw new Error()
            return res
        })
        .then(res => {
            if (!("hitokoto" in res)) throw new Error()
            return res
        })
        .then(res => {
            if (typeof res.hitokoto != "string") throw new Error()
            return res
        })
        .then(res => {
            if (!res.hitokoto) throw new Error()
            return res
        })
        .catch(_ => fallback)
    const racing = await Promise.race([timeout, online])
    const formatted = `
${racing.hitokoto}
${racing.from || racing.from_who
            ? `${"\u3000".repeat(racing.hitokoto.length - 2)}——${racing.from_who ? racing.from_who : ""}\
${racing.from ? `《${racing.from}》` : ""}`
            : ""
        }
`.trim()
    console.log(formatted)
    process.exit()
}

main()