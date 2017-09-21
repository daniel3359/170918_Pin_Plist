//
//  ViewController.swift
//  02_Pin_Plist
//
//  Created by D7702_09 on 2017. 9. 18..
//  Copyright © 2017년 lyw. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var myMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locateToCenter()
        
        //// pList data 가져오기
        //번들-아이폰의 파일 시스템 main 기본
        let path = Bundle.main.path(forResource: "ViewPoint", ofType: "plist")
        print("path = \(String(describing: path))")
        //NSArray -컬렉션 타입 배열안에 타입이 무엇이든지 들어가는것 다양한 내용의 객체를 담을수있다
        //딕셔너리
          //any타입을 사용하기위해 as anyobject를 적용
        let contents = NSArray(contentsOfFile: path!)
        //객체라서 스트링으로 캐스탱 해줘야함
        print("contents = \(String(describing: contents))")
        
        // pin point를 저장하기 위한 배열 선언 - 일반 array선언
        var annotations = [MKPointAnnotation]()
        
        
        //contents(Dictionary의 배열)에서 data 뽑아오기 
        //옵셔널 바인딩 any 는 타입이름 any 실체화된 인스턴스가 AnyObject
        if let myItems = contents {
            for item in myItems {
                //점 찍어서 나오려면 as anyobject 해줘야함
                let lat = (item as AnyObject).value(forKey: "lat")
                let long = (item as AnyObject).value(forKey: "long")
                let title = (item as AnyObject).value(forKey: "title")
                let subTitle = (item as AnyObject).value(forKey: "subTitle")
            
                print("lat = \(String(describing: lat))")
                
                let annotation = MKPointAnnotation()
                //변환
                let myLat = (lat as! NSString).doubleValue
                let myLong = (long as! NSString).doubleValue
                //?는 닐이면 안하고 닐아니면 바로하고 컨디셔널 바인딩
                let myTitle = title as? String
                let mySubTitle = subTitle as? String
               
                annotation.coordinate.latitude = myLat
                annotation.coordinate.longitude = myLong
                annotation.title = myTitle
                annotation.subtitle = mySubTitle
               annotations.append(annotation)
               //핀마다 딜리게이트 다해줘야한다 포문
               myMapView.delegate = self
               
            }
        }else{
            print("contents 는 nil!")
        }
        //보여주기전에 모든 핀의 틀을 다 나오게함
        myMapView.showAnnotations(annotations, animated: true)
        myMapView.addAnnotations(annotations)
     
    }
     func locateToCenter() {
          let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
          //반경
          let span = MKCoordinateSpanMake(0.05, 0.05)
          let resion = MKCoordinateRegionMake(center, span)
          myMapView.setRegion(resion, animated: true)
     }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        var  annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            if annotation.title! == "부산시민공원" {
                annotationView?.pinTintColor = UIColor.green
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named:"citizen_logo.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else if annotation.title! == "DIT 동의과학대학교" {
               annotationView?.pinTintColor = UIColor.yellow
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"DIT_logo.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else {
               annotationView?.pinTintColor = UIColor.cyan
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"다운로드.jpeg")
                annotationView?.leftCalloutAccessoryView = leftIconView
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
     
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        let viewTitle: String = ((viewAnno?.title)!)!
        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
        
        print("\(viewTitle) \(viewSubTitle)")
        
        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

}


