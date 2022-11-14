//
//  ViewController.swift
//  GrandCentralDispach
//
//  Created by Александр Коробицын on 10.11.2022.
//


import UIKit

class ViewController: UIViewController {
    
    private let signals = SygnalsView()
    
    private let firstButton = Button()
    private let secondButton = Button()
    private let thirdButton = Button()
    private let fourthButton = Button()
    private let fifthButton = Button()
    private let sixthButton = Button()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        instanceNavigationBar()
        instanceButtons()
        instanceSignals()
    }
    
    //MARK: - Fetch Image
    
    @objc private func firstAction() {
        let vc = ImageViewController()
        present(vc, animated: true)
    }
    
    //MARK: - Dispach After
    
    @objc private func secondAction() {
        secondButton.setTitle("wait...", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let alert = UIAlertController(title: "Dispach After",
                                          message: nil,
                                          preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            self.secondButton.setTitle("Dispach After", for: .normal)
        }
    }
    
    //MARK: - Barrier / Race Condition
    
    @objc private func thirdAction() {
        
        class saveArray<Element> {
            private var array = [Element]()
            private let queue = DispatchQueue(label: "Barrier", attributes: .concurrent)
            public func add(element: Element) {
                queue.async(flags: .barrier) {
                    self.array.append(element)
                }
            }
            public var elements: [Element] {
                var result = [Element]()
                queue.sync {
                    result = self.array
                }
                return result
            }
        }
        
        let resultArray = saveArray<Int>()
        
        DispatchQueue.concurrentPerform(iterations: 20) {index in
            resultArray.add(element: index)
        }
        print(resultArray.elements)
        
    }
    
    //MARK: - Groups
    
    @objc private func fourAction() {
        let queue = DispatchQueue(label: "Groups", attributes: .concurrent)
        let firstGroup = DispatchGroup()
        let secondGroup = DispatchGroup()
        let lastGroup = DispatchGroup()
        
        firstGroup.enter()
        queue.async(group: firstGroup) {
            DispatchQueue.main.async {
                self.signals.first.image = UIImage(named: "active")
                print("active")
            }
        }
                
        queue.async(group: firstGroup) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.signals.second.image = UIImage(named: "active")
                print("active")
                firstGroup.leave()
            }
        }
        firstGroup.notify(queue: .main) {
            print("First Group Work End")
        }
        
        
        secondGroup.enter()
        queue.async(group: secondGroup) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.signals.third.image = UIImage(named: "active")
                print("active")
            }
        }

        queue.async(group: secondGroup) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.signals.fourth.image = UIImage(named: "active")
                print("active")
                secondGroup.leave()
            }
        }
        secondGroup.notify(queue: .main) {
            print("Second Group Work End")
        }
        
        
        queue.async(group: lastGroup, execute: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                self.signals.first.image = UIImage(named: "notActive")
                self.signals.second.image = UIImage(named: "notActive")
                self.signals.third.image = UIImage(named: "notActive")
                self.signals.fourth.image = UIImage(named: "notActive")
            }
            
        })
       
        print("first print")
        
        let timeoutTimedOut = lastGroup.wait(timeout: .now())
        let timeoutSuccess = lastGroup.wait(timeout: .now() + 2)
        print(timeoutTimedOut)
        print(timeoutSuccess)
        
        
        
    }
    
    //MARK: - Blocks
    
    
    @objc private func fiveAction() {
        
        let firstQueue = DispatchQueue(label: "firstQueue",
                                  qos: .utility,
                                  attributes: .concurrent)
        let secondQueue = DispatchQueue(label: "secondQueue",
                                  qos: .utility,
                                  attributes: .concurrent)
        let thirdQueue = DispatchQueue(label: "thirdQueue",
                                       qos: .utility,
                                       attributes: .concurrent)
        let fourthQueue = DispatchQueue(label: "fourthQueue",
                                        attributes: .concurrent)
        
        
        let firstWorkItem = DispatchWorkItem(qos: .utility) {
            DispatchQueue.main.async {
                self.signals.first.image = UIImage(named: "active")
                print("First Block")
            }
        }
        
        let secondWorkItem = DispatchWorkItem(qos: .utility) {
            DispatchQueue.main.async {
                self.signals.second.image = UIImage(named: "active")
                self.signals.third.image = UIImage(named: "active")
                print("Second Block")
            }
        }
        
        let thirdWorkItem = DispatchWorkItem(qos: .utility) {
            DispatchQueue.main.async {
                self.signals.fourth.image = UIImage(named: "active")
                print("Third Block")
            }
        }
        
        let fourthWorkItem = DispatchWorkItem(qos: .utility) {
            DispatchQueue.main.async {
                self.signals.first.image = UIImage(named: "notActive")
                self.signals.second.image = UIImage(named: "notActive")
                self.signals.third.image = UIImage(named: "notActive")
                self.signals.fourth.image = UIImage(named: "notActive")
                print("Fourth Block")
            }
        }
        
        firstQueue.asyncAfter(deadline: .now() + 1, execute: firstWorkItem)
        firstWorkItem.wait()
        thirdWorkItem.cancel()
        secondQueue.asyncAfter(deadline: .now() + 1, execute: secondWorkItem)
        thirdQueue.async(execute: thirdWorkItem)
        fourthQueue.asyncAfter(deadline: .now() + 2, execute: fourthWorkItem)
        
        


    }
    
    //MARK: - Semaphores
    
    @objc private func sixAction() {
        let queue = DispatchQueue(label: "Semaphores", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 0)
        
        semaphore.signal()
        queue.async {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.signals.first.image = UIImage(named: "active")
            }
            semaphore.signal()
        }

        queue.async {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.signals.second.image = UIImage(named: "active")
            }
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.signals.third.image = UIImage(named: "active")
            }
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.signals.fourth.image = UIImage(named: "active")
            }
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.signals.first.image = UIImage(named: "notActive")
                self.signals.second.image = UIImage(named: "notActive")
                self.signals.third.image = UIImage(named: "notActive")
                self.signals.fourth.image = UIImage(named: "notActive")
            }
            semaphore.signal()
        }
        
        
    }
    
    //MARK: - Instance Navigation Bar
    
    private func instanceNavigationBar() {
        title = "GCD"
        let bar = navigationController?.navigationBar
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        bar?.prefersLargeTitles = true
        bar?.scrollEdgeAppearance = appearence
    }
    
    
    //MARK: - Instance Buttons
    
    private func instanceButtons() {
        let buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton]
        for button in buttons {
            view.addSubview(button)
        }
        
        firstButton.addTarget(self, action: #selector(firstAction), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondAction), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(thirdAction), for: .touchUpInside)
        fourthButton.addTarget(self, action: #selector(fourAction), for: .touchUpInside)
        fifthButton.addTarget(self, action: #selector(fiveAction), for: .touchUpInside)
        sixthButton.addTarget(self, action: #selector(sixAction), for: .touchUpInside)
      
        
        firstButton.setTitle("Fetch Image", for: .normal)
        secondButton.setTitle("Dispach After", for: .normal)
        thirdButton.setTitle("Barrier -> Console", for: .normal)
        fourthButton.setTitle("Groups +-> Console", for: .normal)
        fifthButton.setTitle("Blocks +-> Console", for: .normal)
        sixthButton.setTitle("Simaphores", for: .normal)

        NSLayoutConstraint.activate([
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 20),
            thirdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 20),
            fourthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fourthButton.topAnchor.constraint(equalTo: thirdButton.bottomAnchor, constant: 20),
            fifthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fifthButton.topAnchor.constraint(equalTo: fourthButton.bottomAnchor, constant: 20),
            sixthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sixthButton.topAnchor.constraint(equalTo: fifthButton.bottomAnchor, constant: 20)
        ])
    }
    
    //MARK: - Instance Views
    
    private func instanceSignals() {
        view.addSubview(signals)
        signals.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signals.widthAnchor.constraint(equalToConstant: 280),
            signals.heightAnchor.constraint(equalToConstant: 70),
            signals.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signals.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ]) 
    }
}

