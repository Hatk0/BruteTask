import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Password", for: .normal)
        button.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(resultLabel)
        view.addSubview(activityIndicator)
        view.addSubview(generateButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            textField.widthAnchor.constraint(equalToConstant: 200),
            
            resultLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            generateButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Action
    
    @objc
    func generatePassword() {
        
    }
    
    // MARK: - Generate password methods

    func generateRandomPassword() -> String {
        let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<8).map { _ in characters.randomElement()! })
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)

            if password == passwordToUnlock {
                DispatchQueue.main.async {
                    self.resultLabel.text = "Password: \(password)"
                }
                break
            }
        }
    }
}

// MARK: - Extension and methods

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index]) : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    } else {
        str.replace(at: str.count - 1, with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}
