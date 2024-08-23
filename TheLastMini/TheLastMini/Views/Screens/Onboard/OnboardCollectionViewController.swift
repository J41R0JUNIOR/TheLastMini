import UIKit

class OnboardCollectionViewController: UICollectionViewController {
    
    private lazy var onboardCollection: OnboardCollectionView = {
        let view = OnboardCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() 
    
    override func loadView() {
        self.view = onboardCollection
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupCells()
    }
}

extension OnboardCollectionViewController: ViewCode {
    func addViews() {
        if onboardCollection != self.view {
            self.view.addSubview(onboardCollection)

                }
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            onboardCollection.topAnchor.constraint(equalTo: view.topAnchor),
            onboardCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStyle() {}
    
    func setupCells() {
        let model: [UIView] = [
                   FirstPageOnboad(title: PrimaryNames.gameName.rawValue, text: OnboardText.firstPageText.text, image: UIImage(named: "AppIcon")!),
                   HowToPlayPageOnboad(title: OnboardText.howToPlay.text, text: OnboardText.secondPageText.text, image: UIImage(named: "posicionar")!),
                   HowToPlayPageOnboad(title: OnboardText.howToPlay.text, text: OnboardText.thirdPageText.text, image: UIImage(named: "jogar")!)
               ]
        self.onboardCollection.configure(model)
    }
}

enum PrimaryNames: String {
    case gameName = "Kuruma Driver"
}

enum OnboardText {
    case firstPageText
    case howToPlay
    case secondPageText
//    case thirdPageTitle
    case thirdPageText
    case fourthPageText

    var text: String {
        switch self {
        case .firstPageText:
            return """
                    Bem-vindo ao \(PrimaryNames.gameName.rawValue)!\n
                    Prepare-se para uma emocionante experiência de corrida em Realidade Aumentada!\n No \(PrimaryNames.gameName.rawValue), você não apenas joga, mas vive a corrida no mundo real.
                    """
        case .howToPlay:
            return "How to play?"
        case .secondPageText:
            return """
                    Posicione a Pista: Coloque uma pista de corrida no chão usando seu dispositivo. A pista será projetada no ambiente ao seu redor, tornando cada corrida única.
                        
                    """
//        case .thirdPageTitle:
//            return "Nothing to do"
        case .thirdPageText:
            return """
                     Dirija o Carro: Utilize os botões intuitivos para controlar seu carro:
                     Acelere para ganhar velocidade.
                     Frear para diminuir a velocidade e fazer curvas mais seguras.
                     Esquerda e Direita para direcionar o carro pelo percurso.
                                 
                    """

        case .fourthPageText:
            return """
                     Evite Obstáculos: Fique atento aos obstáculos que aparecem na pista. Eles podem afetar a dirigibilidade e desafiar suas habilidades de controle.
                     Compita com Amigos: Mostre suas habilidades e veja quem é o melhor piloto! O tempo de volta de cada jogador é registrado e comparado, permitindo que você compita por quem faz o melhor tempo.
                     Dicas para um Desempenho Ideal:
                             
                     Atenção ao Trajeto: Navegue cuidadosamente para evitar obstáculos e otimizar seu tempo.
                     Prática: Quanto mais você jogar, melhor ficará em prever e reagir às mudanças na pista.
                     Divirta-se e boa sorte na pista!
            """
        }
    }
}

