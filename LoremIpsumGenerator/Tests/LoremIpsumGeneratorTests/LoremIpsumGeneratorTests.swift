import XCTest
@testable import LoremIpsumGenerator

final class LoremIpsumGeneratorTests: XCTestCase {
    func testLoremIpsumGenerator() async throws {
        let generator = LoremIpsumGenerator()
        
        let textA = await generator.generateText(length: .init(unit: .word, count: 150), firstWordPair: .init("Lorem", "ipsum"))
        let textB = await generator.generateText(length: .init(unit: .paragraph, count: 500))
        let textC = await generator.generateText(length: .init(unit: .word, count: -5))
        let textD = await generator.generateText(length: .init(unit: .paragraph, count: 0))
        let textE = await generator.generateText(length: .init(unit: .word, count: 4),
                                                 firstWordPair: WordPair("magnam", "aliquam"))
        
        XCTAssertEqual(textA.words[...1].joined(separator: " "), "Lorem ipsum")
        XCTAssertEqual(textA.words.count, 150)
        XCTAssertEqual(textB.split(separator: "\n").count, 500)
        XCTAssertEqual(textC, "")
        XCTAssertEqual(textD, "")
        XCTAssertEqual(textE, "Magnam aliquam quaerat voluptatem.")
    }
    
    func testCustomTextGenerator() async throws {
        let text = """
                   El paso de la borrasca Karlotta está justificando a la perfección la alerta naranja por viento decretada en buena parte de la costa gallega, aviso que desciende a amarillo en el resto de la comunidad. Las ráfagas están siendo muy intensas, llegando a superar los 200 kilómetros por hora en Viveiro, y están provocando un reguero de incidencias.

                   Aviones y trenes lo han notado desde primera hora. Hasta cinco vuelos que debían aterrizar en aeropuertos gallegos no han podido hacerlo. Dos de ellos, el UX7233 y el IB514, tenían como destino el aeropuerto coruñés de Alvedro, pero tuvieron que regresar a Madrid. Uno de ellos, operado por Iberia, llegó incluso a intentar aterrizar en Santiago, pero tampoco lo consiguió. Al no tomar tierra estos aviones, tuvieron que cancelarse sus posteriores salidas. En Lavacolla tampoco pudo aterrizar un vuelo procedente de Bilbao, que fue desvío a Madrid.

                   Ya a media mañana hubo problemas con otros dos aviones, en concreto dos enlaces de Ryanair con origen Londres y destino Santiago y Vigo, que fueron desviados también a la capital española.

                   El tráfico ferroviario en el Eje Atlántico también se vio afectado. A primera hora, el viento tumbó un árbol sobre la vía entre Catoira y Pontecesures, lo que acabó provocando que el tren con salida desde A Coruña que debía llegar a Vigo a las 7:40 horas, lo hiciese pasadas las nueve de la mañana. Los trenes afectados tuvieron que desviarse entre la bifurcación de Angueira y Vilagarcía, y aunque según ADIF la incidencia se solucionó en aproximadamente una hora, sus consecuencias en forma de retrasos se han ido arrastrando a lo largo de la mañana.

                   Además, el temporal de viento también ha llevado a Renfe a suspender la circulación de trenes entre A Coruña y Ferrol, estableciendo un servicio alternativo de transporte por carretera, y tampoco circulan los trenes de ancho métrico (FEVE) entre Ortigueira, Ribadeo y Oviedo, como mínimo hasta las cuatro de la tarde. Además, Renfe avisó a mediodía de posibles demoras entre Ferrol y Ortigueira por la caída de un árbol en la infraestructura entre Moeche y Cerdido, que interrumpió durante un tiempo la circulación.
                   """
        
        let generator = LoremIpsumGenerator(fromCustomText: text)
        
        let textA = await generator.generateText(length: .init(unit: .word, count: 150))
        let textB = await generator.generateText(length: .init(unit: .paragraph, count: 500))
        let textC = await generator.generateText(length: .init(unit: .word, count: -5))
        let textD = await generator.generateText(length: .init(unit: .paragraph, count: 0))
        let textE = await generator.generateText(length: .init(unit: .word, count: 4),
                                                 firstWordPair: WordPair("El", "tráfico"))
        
        XCTAssertEqual(textA.words.count, 150)
        XCTAssertEqual(textB.split(separator: "\n").count, 500)
        XCTAssertEqual(textC, "")
        XCTAssertEqual(textD, "")
        XCTAssertEqual(textE, "El tráfico ferroviario en.")
        
        let generator2 = LoremIpsumGenerator(fromCustomText: "")
        let text1 = await generator2.generateText(length: .init(unit: .word, count: 150))
        XCTAssertEqual(text1, "")
    }
}
