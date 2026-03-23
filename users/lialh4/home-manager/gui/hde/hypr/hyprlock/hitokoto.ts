const main = async () => {
    const hitokoto = await fetch("https://v1.hitokoto.cn/?c=i")
        .then(res => res.json())
        .then(res => {
            if (!(res instanceof Object)) throw new Error()
            return res
        })
        .then(res => {
            if (!("hitokoto" in res)) throw new Error()
            return res
        })
        .then(res => {
            if (!res.hitokoto) throw new Error()
            return res
        })
        .catch(_ => ({
            hitokoto: "数人世相逢，百年欢笑，能得几回又。",
            from: "摸鱼儿·记年时人人何处",
            from_who: "何梦桂"
        }))
    const formatted = `
${hitokoto.hitokoto}
\t——${hitokoto.from_who ? hitokoto.from_who : ""}\
${hitokoto.from ? `《${hitokoto.from}》` : ""}
`.trim()
    console.log(formatted)
}

main()