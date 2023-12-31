//
//  ImportanceAndDeadlineView.swift
//  To-do-list
//
//  Created by @_@
//

import UIKit

final class ImportanceAndDeadlineView: UIView {
    
    //MARK: - Properties
    weak var delegate: EditorView?
    var todoItem: TodoItem?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var minorDeadlineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var importanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = .body
        label.tintColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        return label
    }()
    
    lazy var importanceSegmentedControl: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: ["", "нет", ""])
        let unimportantImage = UIImage(named: "unimportant")
        let importantImage = UIImage(named: "important")
        
        segmentedControll.setImage(unimportantImage, forSegmentAt: 0)
        segmentedControll.setImage(importantImage, forSegmentAt: 2)
        segmentedControll.selectedSegmentIndex = 1
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControll
    }()
    
    private lazy var divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        
        return view
    }()
    
    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        
        return view
    }()
    
    private lazy var deadlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = .body
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        return label
    }()
    
    lazy var deadlineSwitch: UISwitch = {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitchDidToggled), for: .valueChanged)
        
        return deadlineSwitch
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .backSecondary
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "Ru_ru")
        picker.calendar.firstWeekday = 2
        picker.addTarget(
            self,
            action: #selector(datePickerValueChanged),
            for: .valueChanged
        )
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    lazy var deadlineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("25 июня 2021", for: .normal)
        button.addTarget(self, action: #selector(deadlineButtonDidTapped), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        todoItem = delegate?.todoItem
        
        setupView()
        setConstraints()
        setupDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    @objc private func deadlineSwitchDidToggled() {
        showDeadlineButton(bool: true)
        
        if !deadlineSwitch.isOn && !datePicker.isHidden {
            deadlineButtonDidTapped()
        } else if deadlineSwitch.isOn {
            deadlineButton.setTitle(datePicker.date.toString, for: .normal)
        }
    }
    
    // Shows/Hides deadlineButton
    func showDeadlineButton(bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.deadlineButton.alpha = self.deadlineSwitch.isOn ? 1.0 : 0.0
                self.deadlineButton.isHidden = !self.deadlineSwitch.isOn
            })
        } else {
            self.deadlineButton.alpha = 0
            self.deadlineButton.isHidden = true
        }
    }
    
    // Shows/hides datePicker
    @objc func deadlineButtonDidTapped() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.setDefaultDatePicker()
        })
    }
    
    // Setups date for datePicker
    private func setupDate() {
        let calendar = Calendar.current
        datePicker.minimumDate = calendar.startOfDay(for: Date())
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: Date()) {
            datePicker.date = nextDay
        }
    }
    
    // Changes title of deadlineButton when date in datePicker changes
    @objc private func datePickerValueChanged() {
        deadlineButton.setTitle(datePicker.date.toString, for: .normal)
    }
    // TODO: Rename
    // Shows/hides datePicker
    private func setDefaultDatePicker() {
        setupDate()
        
        self.datePicker.isHidden = !datePicker.isHidden
        self.divider2.isHidden = !divider2.isHidden
        self.divider2.alpha = divider2.isHidden ? 0.0 : 1.0
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .backSecondary
        layer.cornerRadius = 16
        divider2.isHidden = true
        
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(importanceStackView)
        importanceStackView.addArrangedSubview(importanceLabel)
        importanceStackView.addArrangedSubview(importanceSegmentedControl)
        mainStackView.addArrangedSubview(divider1)
        
        deadlineStackView.addArrangedSubview(minorDeadlineStackView)
        minorDeadlineStackView.addArrangedSubview(deadlineLabel)
        minorDeadlineStackView.addArrangedSubview(deadlineButton)
        deadlineStackView.addArrangedSubview(deadlineSwitch)
        mainStackView.addArrangedSubview(deadlineStackView)
        mainStackView.addArrangedSubview(divider2)
        mainStackView.addArrangedSubview(datePicker)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            importanceStackView.heightAnchor.constraint(equalToConstant: 56),
            
            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: 150),
            importanceSegmentedControl.heightAnchor.constraint(equalToConstant: 36),
            
            deadlineStackView.heightAnchor.constraint(equalToConstant: 56),
            
            deadlineButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
