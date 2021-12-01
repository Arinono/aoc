import fs from 'fs'
import fetch from 'node-fetch'

const YEAR = 2021

const filesP = []

console.time('Done in')

if (fs.existsSync(`${YEAR}`) && fs.statSync(`${YEAR}`).isDirectory()) {
  console.log('Directory already present')
  process.exit(1)
}

fs.mkdirSync(`${YEAR}`)

for (let i = 1; i < 26; i++) {
  filesP.push(fetch(`https://adventofcode.com/${YEAR}/day/${i}/input`, {
    headers: {
      cookie: "session="
    }
  }))
}

Promise.allSettled(filesP)
  .then((files) => {
    const contentsP = []
    for (let i = 0; i < files.length; i++) {
      if (files[i].status === "fulfilled") {
        contentsP.push(files[i].value.text())
      }
    }

    Promise.allSettled(contentsP)
      .then(contents => {
        const writesP = []
        for (let i = 0; i < contents.length; i++) {
          if (contents[i].status === "fulfilled") {
            writesP.push(new Promise(resolve => fs.writeFile(`${YEAR}/${(i + 1).toString().padStart(2, '0')}.txt`, contents[i].value, { encoding: 'utf-8' }, resolve)))
          }
        }

        Promise.allSettled(writesP)
          .then(
            () => console.timeEnd('Done in'),
            console.error
          )
      }, console.error)
  }, console.error)
