import React, { useState } from 'react';
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { profileFormConfig } from "@/data/profileFormData";

const ProfileForm = () => {
  const [formData, setFormData] = useState({});
  const [currentSection, setCurrentSection] = useState(0);

  const handleInputChange = (fieldId, value) => {
    setFormData(prev => ({ ...prev, [fieldId]: value }));
  };

  const handleMultiselectChange = (fieldId, value, limit) => {
    setFormData(prev => {
      const currentValues = prev[fieldId] || [];
      const newValues = currentValues.includes(value)
        ? currentValues.filter(v => v !== value)
        : limit && currentValues.length >= limit
        ? currentValues
        : [...currentValues, value];
      
      return { ...prev, [fieldId]: newValues };
    });
  };

  const renderField = (field) => {
    const value = formData[field.id] || (field.type === 'multiselect' ? [] : '');

    switch (field.type) {
      case 'text':
        return (
          <div key={field.id} className="space-y-2">
            <Label htmlFor={field.id} className="text-white">
              {field.label} {field.required && <span className="text-red-400">*</span>}
            </Label>
            <Input
              id={field.id}
              value={value}
              onChange={(e) => handleInputChange(field.id, e.target.value)}
              placeholder={field.placeholder}
              className="bg-white/10 border-white/20 text-white placeholder-purple-300"
              required={field.required}
            />
          </div>
        );

      case 'select':
        return (
          <div key={field.id} className="space-y-2">
            <Label htmlFor={field.id} className="text-white">
              {field.label} {field.required && <span className="text-red-400">*</span>}
            </Label>
            <Select value={value} onValueChange={(val) => handleInputChange(field.id, val)}>
              <SelectTrigger className="bg-white/10 border-white/20 text-white">
                <SelectValue placeholder={`Select ${field.label.toLowerCase()}`} />
              </SelectTrigger>
              <SelectContent>
                {field.options.map((option) => (
                  <SelectItem 
                    key={typeof option === 'string' ? option : option.value} 
                    value={typeof option === 'string' ? option : option.value}
                  >
                    {typeof option === 'string' ? option : option.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        );

      case 'multiselect':
        return (
          <div key={field.id} className="space-y-3">
            <Label className="text-white">
              {field.label} {field.required && <span className="text-red-400">*</span>}
            </Label>
            <div className="flex flex-wrap gap-2">
              {field.options.map((option) => {
                const isSelected = value.includes(option);
                const isDisabled = field.limit && !isSelected && value.length >= field.limit;
                
                return (
                  <Badge
                    key={option}
                    variant={isSelected ? "default" : "outline"}
                    className={`cursor-pointer transition-colors ${
                      isSelected 
                        ? 'bg-purple-500 text-white border-purple-400' 
                        : isDisabled
                        ? 'opacity-50 cursor-not-allowed'
                        : 'bg-white/10 text-purple-200 border-white/20 hover:bg-white/20'
                    }`}
                    onClick={() => !isDisabled && handleMultiselectChange(field.id, option, field.limit)}
                  >
                    {option}
                  </Badge>
                );
              })}
            </div>
            {field.limit && (
              <p className="text-purple-300 text-sm">
                {value.length}/{field.limit} selected
              </p>
            )}
          </div>
        );

      default:
        return null;
    }
  };

  const currentSectionData = profileFormConfig.sections[currentSection];

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-purple-800 to-purple-900 p-8">
      <div className="max-w-4xl mx-auto">
        {/* Section Navigation */}
        <div className="flex justify-center mb-8">
          <div className="flex space-x-2">
            {profileFormConfig.sections.map((section, index) => (
              <Button
                key={section.id}
                variant={index === currentSection ? "default" : "outline"}
                size="sm"
                onClick={() => setCurrentSection(index)}
                className={index === currentSection 
                  ? "bg-purple-500 text-white" 
                  : "border-white/20 text-purple-200 hover:bg-white/10"
                }
              >
                {index + 1}. {section.title}
              </Button>
            ))}
          </div>
        </div>

        {/* Current Section */}
        <Card className="bg-white/5 border-white/10">
          <CardHeader>
            <CardTitle className="text-white text-2xl">{currentSectionData.title}</CardTitle>
            <CardDescription className="text-purple-200">
              {currentSectionData.description}
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            {currentSectionData.fields.map(renderField)}
          </CardContent>
        </Card>

        {/* Navigation */}
        <div className="flex justify-between mt-8">
          <Button
            variant="outline"
            onClick={() => setCurrentSection(prev => Math.max(0, prev - 1))}
            disabled={currentSection === 0}
            className="border-white/20 text-purple-200 hover:bg-white/10"
          >
            Previous
          </Button>
          
          <Button
            onClick={() => {
              if (currentSection === profileFormConfig.sections.length - 1) {
                console.log('Final Form Data:', formData);
                // Send to your N8N workflow here
                alert('Profile completed! Check console for data.');
              } else {
                setCurrentSection(prev => prev + 1);
              }
            }}
            className="bg-purple-500 hover:bg-purple-600 text-white"
          >
            {currentSection === profileFormConfig.sections.length - 1 ? 'Complete Profile' : 'Next'}
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ProfileForm;
