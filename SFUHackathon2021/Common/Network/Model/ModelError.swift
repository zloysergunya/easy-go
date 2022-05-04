import Foundation

struct ModelError: Error {
    var error: APIError?
    let status: Int
    
    var message: String {
        get {
            if let error = error {
                return error.message
            }
            
            switch status {
            case 200:
                return "Произошла ошибка во время получения данных с сервера"
            case 404:
                return "Для Вашей учетной записи нет данных для отображения"
            case 500:
                return "Ошибка при получении данных.\n Пожалуйста повторите попытку позднее"
            default:
                return "Возможно, идет обновление данных на сервере, либо отсутствует доступ в Интернет.\nПроверьте интернет-соединение и повторите попытку"
            }
        }
    }
    
    var code: Int {
        get {
            return status
        }
    }
}
