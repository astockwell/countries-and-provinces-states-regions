import _ from 'lodash'
import fs from 'fs'
import path from 'path'
import Promise from 'bluebird'

Promise.promisifyAll(fs)

function getProvinces () {
  return fs.readdirAsync('./countries')
    .then(countryFiles => {
      let props = _.chain(countryFiles)
      .map(countryFile => {
        let file = path.basename(countryFile, path.extname(countryFiles))
        return [file, fs.readFileAsync(`./countries/${countryFile}`, 'utf8').then(JSON.parse)]
      })
      .zipObject()
      .value()
      return Promise.props(props)
    })
}

function getCountries () {
  return fs.readFileAsync('./countries.json', 'utf8').then(JSON.parse)
}

function assemble () {
  return Promise.props({
    'provinces': getProvinces(),
    'countries': getCountries(),
  })
}

function prettyPrintJSON (json) {
  return JSON.stringify(json, null, 2)
}

function writeFile () {
  return assemble()
    .then(data => {
      return fs.writeFileAsync('./index.js', prettyPrintJSON(data))
    })
}

writeFile()
.catch(console.error.bind(console))
