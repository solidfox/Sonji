//
//  ModelController.swift
//  Sonji
//
//  Created by Daniel Schlaug on 6/29/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements cardSetViewController:viewControllerBeforeViewController: and cardSetViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

class ModelController: NSObject, CardSetViewControllerDataSource, UIAlertViewDelegate {
    
    let _characterTester = CharacterTester()
    let _storyboard: UIStoryboard
    
    func firstViewController() -> UIViewController {
        return next()!
    }
    
    func _instantiateDrawQuizViewController() -> CharacterDrawQuizViewController {
        let nextViewController = _storyboard.instantiateViewControllerWithIdentifier("CharacterDrawQuizViewController") as! CharacterDrawQuizViewController
        return nextViewController
    }
    
    init(storyboard: UIStoryboard) {
        self._storyboard = storyboard
    }
    
    func next(previous:UIViewController? = nil) -> UIViewController? {
        let newC = _instantiateDrawQuizViewController()
        _characterTester.loadNextQuiz() {nextQuiz in newC.characterDrawQuiz = nextQuiz}
        return newC
    }
    
    // #pragma mark - Page View Controller Data Source
    
    func cardSetViewController(cardSetViewController: CardSetViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var previousViewController: CharacterDrawQuizViewController? = nil
        if let characterDrawQuizViewController = viewController as? CharacterDrawQuizViewController {
            if let quiz = characterDrawQuizViewController.characterDrawQuiz {
                if let previousQuiz = _characterTester.quizBeforeQuiz(quiz) {
                    previousViewController = _instantiateDrawQuizViewController()
                    previousViewController!.characterDrawQuiz = previousQuiz
                }
            }
        }
        return previousViewController
    }

    func cardSetViewController(cardSetViewController: CardSetViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var nextViewController: UIViewController? = nil
        
        if let characterDrawQuizViewController = viewController as? CharacterDrawQuizViewController {
            if let quiz = characterDrawQuizViewController.characterDrawQuiz {
                let newController = _instantiateDrawQuizViewController()
                nextViewController = newController
                _characterTester.quizAfterQuiz(quiz) {
                    nextQuiz in newController.characterDrawQuiz = nextQuiz
                }
            }
        } else {
            nextViewController = next(viewController)
        }
        return nextViewController
    }

    
}

