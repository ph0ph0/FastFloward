import Artist from 0x01

pub fun serialzeStringArray(_ lines: [String]): String {
    var buffer = ""
    for line in lines {
        // log(line)
        buffer = buffer.concat(line)
    }
    return buffer
}

pub fun convertBackToPixelArray(_ pixelString: String, width: Int, height: Int): [String] {
    var pixelArray: [String] = []
    let width = width
    let height = height

    let NumberOfPixels = pixelString.length
    var start = 0
    var end = width
    while end <= NumberOfPixels {
        let slice = pixelString.slice(from: start, upTo: end)
        pixelArray.append(slice)
        start = start + (width)
        end = end + width
    }

    return pixelArray
}

pub fun addFrameEnds(to pixelArray: [String], width: Int, height: Int): [String] {
    var frameEndArray: [String] = []


    let corner = "x"
    let side = "-"

    var i = 1
    while i <= width + 2 {
        if (i == 1 || i == width + 2) {
            frameEndArray.append(corner)
        } else {
            frameEndArray.append(side)
        }
        i = i + 1
    }
    
    let frameEnd = serialzeStringArray(frameEndArray)
    pixelArray.insert(at: 0, frameEnd)
    pixelArray.insert(at: height + 1, frameEnd)
    return pixelArray
}

pub fun addFrameSides(to pixelArray: [String], width: Int, height: Int): [String] {

    var i = 0
    let side = "|"
    while i < pixelArray.length {
        if (i == 0 || i == pixelArray.length - 1) {
            i = i + 1
            continue
        }
        pixelArray[i] = side.concat(pixelArray[i])
        pixelArray[i] = pixelArray[i].concat(side)

        i = i + 1
    }
    return pixelArray
}

pub fun frameCanvas(_ canvas: Artist.Canvas): Artist.Canvas {
    let pixels = canvas.pixels
    let width = Int(canvas.width)
    let height = Int(canvas.height)

    var pixelArray = convertBackToPixelArray(pixels, width: width, height: height)

    pixelArray= addFrameEnds(to: pixelArray, width: width, height: height)
    pixelArray = addFrameSides(to: pixelArray, width: width, height: height)
    let framedCanvas = Artist.Canvas(width: UInt8(width + 2), height: UInt8(height + 2), pixels: serialzeStringArray(pixelArray))
    return framedCanvas
}

pub fun display(canvas: Artist.Canvas) {
    let framedCanvas = frameCanvas(canvas)
    log(framedCanvas)
}

pub fun printCollectionContents(_ collectionRef: &Artist.Collection) {
  for key in collectionRef.pictures {
    let picture = collectionRef[key] 
    let canvas = picture.canvas
    display(canvas: canvas)
  }
}

pub fun showArtistsCollection(_ address: Address) {
  log("Showing collection for ".concat(address.toString()))
  if let collectionRef = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistCollection).borrow() {
    printCollectionContents(collectionRef)
  } else {
    log("No collection yet")
  }

}

pub fun main() {
    
    let addresses: [Address] = [0x01, 0x02, 0x03, 0x04, 0x05]

    for address in addresses {
      showArtistsCollection(address)
    } 

}